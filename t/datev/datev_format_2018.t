use strict;
use Test::More;
use Test::Deep qw(cmp_deeply);

use lib 't';

use_ok 'Support::TestSetup';
use SL::DATEV qw(:CONSTANTS);
use SL::Dev::ALL qw(:ALL);
use List::Util qw(sum);
use SL::DB::Buchungsgruppe;
use SL::DB::Chart;
use DateTime;
use Data::Dumper;
use utf8;

Support::TestSetup::login();

my $dbh = SL::DB->client->dbh;

clear_up();

my $d = SL::DB::Default->get;
$d->update_attributes(datev_export_format => 'cp1252');

my $ustid           = 'DE123456788';
my $buchungsgruppe7 = SL::DB::Manager::Buchungsgruppe->find_by(description => 'Standard 7%') || die "No accounting group for 7\%";
my $date            = DateTime->new(year => 2017, month =>  7, day => 19);
my $department      = create_department(description => 'Kästchenweiße heiße Preise');
my $project         = create_project(projectnumber => 2017, description => '299');
my $bank            = SL::DB::Manager::Chart->find_by(description => 'Bank') || die 'Can\'t find chart "Bank"';
my $customer        = new_customer(name => 'Test customer', ustid => $ustid)->save();
my $part1 = new_part(partnumber => '19', description => 'Part 19%')->save;
my $part2 = new_part(
  partnumber         => '7',
  description        => 'Part 7%',
  buchungsgruppen_id => $buchungsgruppe7->id,
)->save;

my $invoice = create_sales_invoice(
  invnumber    => "ݗݘݰݶ",
  itime        => $date,
  gldate       => $date,
  taxincluded  => 0,
  transdate    => $date,
  invoiceitems => [ create_invoice_item(part => $part1, qty =>  3, sellprice => 550),
                    create_invoice_item(part => $part2, qty => 10, sellprice => 50),
                  ],
  department_id    => $department->id,
  globalproject_id => $project->id,
  customer_id      => $customer->id,
);

# lets make a boom
# generate_datev_* doesn't care about encoding but
# csv_buchungsexport does! all arabic will be deleted
# and no string will be left as invnumber

my $datev1 = SL::DATEV->new(
  dbh        => $dbh,
  trans_id   => $invoice->id,
);

my $startdate = DateTime->new(year => 2017, month =>  1, day =>  1);
my $enddate   = DateTime->new(year => 2017, month => 12, day => 31);
my $today     = DateTime->new(year => 2017, month =>  3, day => 17);

$datev1->from($startdate);
$datev1->to($enddate);

$datev1->generate_datev_data;
$datev1->generate_datev_lines;

# check conversion to csv
$datev1->from($startdate);
$datev1->to($enddate);
my ($datev_csv, $die_message);
eval {
  $datev_csv = SL::DATEV::CSV->new(datev_lines  => $datev1->generate_datev_lines,
                                   from         => $startdate,
                                   to           => $enddate,
                                   locked       => $datev1->locked,
                                  );
  my $lines_aref = $datev_csv->lines; # dies only if we assign (do stuff with the data)
  1;
} or do {
  $die_message = $@;
};
ok($die_message =~ m/Falscher Feldwert 'ݗݘݰݶ' für Feld 'belegfeld1' bei der Transaktion mit dem Umsatz von/, 'wrong_encoding');


$invoice->invnumber('ݗݘݰݶmuh');
$invoice->save();

my $datev3 = SL::DATEV->new(
  dbh        => $dbh,
  trans_id   => $invoice->id,
);

$datev3->from($startdate);
$datev3->to($enddate);
$datev3->generate_datev_data;
$datev3->generate_datev_lines;
my ($datev_csv2, $die_message2);
eval {
  $datev_csv2 = SL::DATEV::CSV->new(datev_lines  => $datev3->generate_datev_lines,
                                    from         => $startdate,
                                    to           => $enddate,
                                    locked       => $datev3->locked,
                                   );
my $lines_aref = $datev_csv2->lines; # dies only if we assign (do stuff with the data)

  1;
} or do {
  $die_message2 = $@;
};

# redefine invnumber, we have mixed encodings, should still fail
ok($die_message2 =~ m/Falscher Feldwert 'ݗݘݰݶmuh' für Feld 'belegfeld1' bei der Transaktion mit dem Umsatz von/, 'mixed_wrong_encoding');

# check with good number
$invoice->invnumber('meine muh');
$invoice->save();

$invoice->pay_invoice(chart_id      => $bank->id,
                      amount        => $invoice->open_amount,
                      transdate     => $invoice->transdate->clone->add(days => 10),
                      memo          => 'foobar',
                      source        => 'barfoo',
                     );

my $datev4 = SL::DATEV->new(
  dbh        => $dbh,
  trans_id   => $invoice->id,
);

$datev4->from($startdate);
$datev4->to($enddate);
$datev4->generate_datev_data;
$datev4->generate_datev_lines;

my ($datev_csv4, $die_message3, $lines_aref);
eval {
  $datev_csv4 = SL::DATEV::CSV->new(datev_lines  => $datev4->generate_datev_lines,
                                    from         => $startdate,
                                    to           => $enddate,
                                    locked       => $datev4->locked,
                                   );
  $lines_aref = $datev_csv4->lines; # dies only if we assign (do stuff with the data)

  1;
} or do {
  $die_message3 = $@;
};
ok(!($die_message3), 'no die message');
ok(scalar @{ $datev_csv4->warnings } == 0, 'no warnings');


note('testing invoice without deliverydate');
my @sorted =  sort { $a->[0] cmp $b->[0] } @{ $lines_aref }; # sort by string-comparison of amount
cmp_deeply $sorted[0],
           [ '1963,5', 'S', 'EUR', '', '', '',
             '1400', '8400', '', '1907', 'meine muh',
             '', '', 'Test customer', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', "K\x{e4}stchen",
             '299', '', $ustid, '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '1', '',
             '', '', '', '', '',
           ],
           'invoice without deliverydate 19% tax export ok';
cmp_deeply $sorted[2],
           [ '535', 'S', 'EUR', '', '', '',
             '1400', '8300', '', '1907','meine muh',
             '', '', 'Test customer', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', "K\x{e4}stchen",
             '299', '', $ustid, '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '1', '',
             '', '', '', '', '',
           ],
           'invoice without deliverydate 16% tax export ok';
cmp_deeply $sorted[1],
           [ '2498,5', 'S', 'EUR', '', '', '',
             '1200', '1400', '', '2907','meine muh',
             '', '', 'Test customer', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', "K\x{e4}stchen",
             '299', '', $ustid, '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '1', '',
             '', '', '', '', '',
           ],
           'invoice without deliverydate payment export ok';

# create one haben buchung with GLTransaction today

my $expense_chart = SL::DB::Manager::Chart->find_by(accno => '4660'); # Reisekosten
my $cash_chart    = SL::DB::Manager::Chart->find_by(accno => '1000'); # Kasse

note('testing gl transaction without deliverydate');
my $gl_transaction = create_gl_transaction(
  reference      => "Reise März 2018",
  description    => "Reisekosten März 2018 / Ma Schmidt",
  transdate      => $today,
  taxincluded    => 1,
  type           => undef,
  bookings       => [
                      {
                        chart  => $expense_chart,
                        taxkey => 9,
                        debit  => 100, # net 84.03
                      },
                      {
                        chart  => $cash_chart,
                        taxkey => 0,
                        credit => 100,
                      },
                    ],
);

my $datev2 = SL::DATEV->new(
  dbh        => $dbh,
  trans_id   => $gl_transaction->id,
);

$datev2->from($startdate);
$datev2->to($enddate);
$datev2->generate_datev_data;

my $datev_csv3  = SL::DATEV::CSV->new(datev_lines  => $datev2->generate_datev_lines,
                                      from         => $startdate,
                                      to           => $enddate,
                                      locked       => $datev2->locked,
                                     );

my @data_csv    = sort { $a->[0] cmp $b->[0] } @{ $datev_csv3->lines };
cmp_deeply($data_csv[0],
           [ '100', 'S', 'EUR', '', '', '', '4660', '1000', 9, '1703', 'Reise März 2',
             '', '', 'Reisekosten März 2018 / Ma Schmidt', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '1', '', '', '', '', '', '',
           ],
           'gl datev export without delivery date ok');


note('testing same invoice, but with deliverydate');
# 8400 and 8300 should have deliverydate in datev, payment should not
$invoice->deliverydate(DateTime->new(year => 2017, month =>  7, day => 18));
$invoice->save();

$datev1 = SL::DATEV->new(
  dbh        => $dbh,
  trans_id   => $invoice->id,
);

$datev1->from($startdate);
$datev1->to($enddate);
$datev1->generate_datev_data;
$datev1->generate_datev_lines;

$datev_csv = SL::DATEV::CSV->new(datev_lines  => $datev1->generate_datev_lines,
                                 from         => $startdate,
                                 to           => $enddate,
                                 locked       => $datev1->locked,
);
@sorted    = sort { $a->[0] cmp $b->[0] } @{ $datev_csv->lines };
cmp_deeply $sorted[0],
           [ '1963,5', 'S', 'EUR', '', '', '',
             '1400', '8400', '', '1907', 'meine muh',
             '', '', 'Test customer', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', "K\x{e4}stchen",
             '299', '', $ustid, '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '1', '18072017',
             '', '', '', '', '',
           ],
           'invoice with deliverydate 19% tax export ok';

cmp_deeply $sorted[2],
           [ '535', 'S', 'EUR', '', '', '',
             '1400', '8300', '', '1907','meine muh',
             '', '', 'Test customer', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', "K\x{e4}stchen",
             '299', '', $ustid, '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '1', '18072017',
             '', '', '', '', '',
           ],
           'invoice with deliverydate 16% tax export ok';

cmp_deeply $sorted[1],
           [ '2498,5', 'S', 'EUR', '', '', '',
             '1200', '1400', '', '2907','meine muh',
             '', '', 'Test customer', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', "K\x{e4}stchen",
             '299', '', $ustid, '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '1', '',
             '', '', '', '', '',
           ],
           'invoice with deliverydate payment export ok';

note('testing same gl transaction with deliverydate');
$gl_transaction->deliverydate(DateTime->new(year => 2017, month =>  7, day => 18));
$gl_transaction->save;

$datev1 = SL::DATEV->new(
  dbh        => $dbh,
  trans_id   => $gl_transaction->id,
);

$datev1->from($startdate);
$datev1->to($enddate);
$datev1->generate_datev_data;

$datev_csv   = SL::DATEV::CSV->new(datev_lines  => $datev1->generate_datev_lines,
                                   from         => $startdate,
                                   to           => $enddate,
                                   locked       => $datev1->locked,
);

@sorted      = sort { $a->[0] cmp $b->[0] } @{ $datev_csv->lines };
cmp_deeply($sorted[0],
           [ '100', 'S', 'EUR', '', '', '', '4660', '1000', 9, '1703', 'Reise März 2',
             '', '', 'Reisekosten März 2018 / Ma Schmidt', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '', '', '', '', '', '', '', '', '', '', '',
             '', '', '1', '18072017', '', '', '', '', '',
           ],
          'testing gl transaction with delivery date datev export ok');

# TODO warnings are not yet tested
# currently most of the valid_checks are senseless because of
# the strict input_checks before. Maybe something like encoding mismatch of invnumber,
# can be altered to just a warning (not a mandantory field!)

done_testing();
clear_up();


sub clear_up {
  SL::DB::Manager::AccTransaction->delete_all( all => 1);
  SL::DB::Manager::GLTransaction->delete_all(  all => 1);
  SL::DB::Manager::InvoiceItem->delete_all(    all => 1);
  SL::DB::Manager::Invoice->delete_all(        all => 1);
  SL::DB::Manager::Customer->delete_all(       all => 1);
  SL::DB::Manager::Part->delete_all(           all => 1);
  SL::DB::Manager::Project->delete_all(        all => 1);
  SL::DB::Manager::Department->delete_all(     all => 1);
  SL::DATEV->clean_temporary_directories;
};

1;
