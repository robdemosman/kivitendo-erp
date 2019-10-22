use Test::More tests => 47;

use strict;

use lib 't';

use Carp;
use Data::Dumper;
use Support::TestSetup;
use Test::Exception;

use List::MoreUtils qw(pairwise);
use SL::Controller::CsvImport;

my $DEBUG = 0;

use_ok 'SL::Controller::CsvImport::Part';

use SL::DB::Buchungsgruppe;
use SL::DB::Currency;
use SL::DB::Customer;
use SL::DB::Language;
use SL::DB::Warehouse;
use SL::DB::Pricegroup;
use SL::DB::Price;
use SL::DB::Bin;

my ($translation, $bin1_1, $bin1_2, $bin2_1, $bin2_2, $wh1, $wh2, $bugru, $cvarconfig );
my ($pg1_id, $pg2_id, $pg3_id);

Support::TestSetup::login();

sub reset_state {
  # Create test data

  clear_up();

  $translation     = SL::DB::Language->new(
    description    => 'Englisch',
    article_code   => 'EN',
    template_code  => 'EN',
  )->save;
  $translation     = SL::DB::Language->new(
    description    => 'Italienisch',
    article_code   => 'IT',
    template_code  => 'IT',
  )->save;
  $wh1 = SL::DB::Warehouse->new(
    description    => 'Lager1',
    sortkey        => 1,
  )->save;
  $bin1_1 = SL::DB::Bin->new(
    description    => 'Ort1_von_Lager1',
    warehouse_id   => $wh1->id,
  )->save;
  $bin1_2 = SL::DB::Bin->new(
    description    => 'Ort2_von_Lager1',
    warehouse_id   => $wh1->id,
  )->save;
  $wh2 = SL::DB::Warehouse->new(
    description    => 'Lager2',
    sortkey        => 2,
  )->save;
  $bin2_1 = SL::DB::Bin->new(
    description    => 'Ort1_von_Lager2',
    warehouse_id   => $wh2->id,
  )->save;
  $bin2_2 = SL::DB::Bin->new(
    description    => 'Ort2_von_Lager2',
    warehouse_id   => $wh2->id,
  )->save;

  $cvarconfig = SL::DB::CustomVariableConfig->new(
    module   => 'IC',
    name     => 'mycvar',
    type     => 'text',
    description => 'mein Schatz',
    searchable  => 1,
    sortkey => 1,
    includeable => 0,
    included_by_default => 0,
  )->save;

  foreach ( { id => 1, pricegroup => 'A', sortkey => 1 },
            { id => 2, pricegroup => 'B', sortkey => 2 },
            { id => 3, pricegroup => 'C', sortkey => 3 },
            { id => 4, pricegroup => 'D', sortkey => 4 } ) {
    SL::DB::Pricegroup->new(%{$_})->save;
  }
}

$bugru = SL::DB::Manager::Buchungsgruppe->find_by(description => { like => 'Standard%19%' });

reset_state();

#####
sub test_import {
  my ($file,$settings) = @_;

  my $controller = SL::Controller::CsvImport->new(
    type => 'parts'
  );
  $controller->load_default_profile;
  $controller->profile->set(
    charset      => 'utf-8',
    sep_char     => ';',
    quote_char   => '"',
    numberformat => $::myconfig{numberformat},
  );

  my $csv_part_import = SL::Controller::CsvImport::Part->new(
    settings   => $settings,
    controller => $controller,
    file       => $file,
  );
  #print "profile param type=".$csv_part_import->settings->{parts_type}."\n";

  $csv_part_import->run(test => 0);

  # don't try and save objects that have errors
  $csv_part_import->save_objects unless scalar @{$csv_part_import->controller->data->[0]->{errors}};

  return $csv_part_import->controller->data;
}

$::myconfig{numberformat} = '1000.00';
my $old_locale = $::locale;
# set locale to en so we can match errors
$::locale = Locale->new('en');


my ($entries, $entry, $file);

# different settings for tests
#

my $settings1 = {
                       sellprice_places          => 2,
                       sellprice_adjustment      => 0,
                       sellprice_adjustment_type => 'percent',
                       article_number_policy     => 'update_prices',
                       shoparticle_if_missing    => '0',
                       part_type                 => 'part',
                       part_classification       => 3,
                       default_buchungsgruppe    => ($bugru ? $bugru->id : undef),
                       apply_buchungsgruppe      => 'all',
                };
my $settings2 = {
                       sellprice_places          => 2,
                       sellprice_adjustment      => 0,
                       sellprice_adjustment_type => 'percent',
                       article_number_policy     => 'update_parts',
                       shoparticle_if_missing    => '0',
                       part_type                 => 'mixed',
                       part_classification       => 4,
                       default_buchungsgruppe    => ($bugru ? $bugru->id : undef),
                       apply_buchungsgruppe      => 'missing',
                       default_unit              => 'Stck',
                };

#
#
# starting test of csv imports
# to debug errors in certain tests, run after test_import:
#   die Dumper($entry->{errors});


##### create part with prices and 3 pricegroup prices
$file = \<<EOL;
partnumber;sellprice;lastcost;listprice;unit;pricegroup_1;pricegroup_2;pricegroup_3
P1000;100.10;90.20;95.30;kg;111.11;122.22;133.33
EOL
$entries = test_import($file,$settings1);
$entry = $entries->[0];
#foreach my $err ( @{ $entry->{errors} } ) {
#  print $err;
#}
is $entry->{object}->partnumber,'P1000', 'partnumber';
is $entry->{object}->sellprice, '100.1', 'sellprice';
is $entry->{object}->lastcost,   '90.2', 'lastcost';
is $entry->{object}->listprice,  '95.3', 'listprice';
is $entry->{object}->find_prices( { pricegroup_id => 2 } )->[0]->price,  '122.22000', 'pricegroup_2 price';

##### update prices of part, and price of pricegroup_2, keeping pricegroup_1 and pricegroup_3
$file = \<<EOL;
partnumber;sellprice;lastcost;listprice;unit;pricegroup_2;pricegroup_4
P1000;110.10;95.20;97.30;kg;123.45;144.44
EOL
$entries = test_import($file,$settings1);
$entry = $entries->[0];
is $entry->{object}->sellprice, '110.1', 'updated sellprice';
is $entry->{object}->lastcost,   '95.2', 'updated lastcost';
is $entry->{object}->listprice,  '97.3', 'updated listprice';
# $entry->{object}->prices currently only contains prices pricegroup_2 and pricegroup_4, reload object from db
# printf("%s %s: %s\n", $_->pricegroup_id, $_->pricegroup->pricegroup, $_->price) foreach @{$entry->{object}->prices};
$entry->{object}->load;
is $entry->{object}->find_prices( { pricegroup_id => 1 } )->[0]->price,  '111.11000', 'pricegroup_1 price didn\'t change';
is $entry->{object}->find_prices( { pricegroup_id => 2 } )->[0]->price,  '123.45000', 'pricegroup_2 price was updated';
is $entry->{object}->find_prices( { pricegroup_id => 4 } )->[0]->price,  '144.44000', 'pricegroup_4 price was added';

##### insert parts with warehouse,bin name

$file = \<<EOL;
partnumber;description;warehouse;bin;part_type
P1000;Teil 1000;Lager1;Ort1_von_Lager1;part
P1001;Teil 1001;Lager1;Ort2_von_Lager1;service
P1002;Teil 1002;Lager2;Ort1_von_Lager2;service
P1003;Teil 1003;Lager2;Ort2_von_Lager2;part
EOL
$entries = test_import($file,$settings2);
$entry = $entries->[0];
is $entry->{object}->description, 'Teil 1000', 'Teil 1000 set';
is $entry->{object}->warehouse_id, $wh1->id, 'Lager1';
is $entry->{object}->bin_id, $bin1_1->id, 'Lagerort1';
is $entry->{object}->part_type, 'part', 'Typ ist part';
$entry = $entries->[2];
is $entry->{object}->description, 'Teil 1002', 'Teil 1002 set';
is $entry->{object}->warehouse_id, $wh2->id, 'Lager2';
is $entry->{object}->bin_id, $bin2_1->id, 'Lagerort1';
is $entry->{object}->part_type, 'service', 'Typ ist service';

##### update warehouse and bin
$file = \<<EOL;
partnumber;description;warehouse;bin;part_type
P1000;Teil 1000;Lager2;Ort1_von_Lager2;part
P1001;Teil 1001;Lager1;Ort1_von_Lager1;part
P1002;Teil 1002;Lager2;Ort1_von_Lager1;part
P1003;Teil 1003;Lager2;kein Lagerort;part
EOL
$entries = test_import($file,$settings2);
$entry = $entries->[0];
is $entry->{object}->description, 'Teil 1000', 'Teil 1000 set';
is $entry->{object}->warehouse_id, $wh2->id, 'Lager2';
is $entry->{object}->bin_id, $bin2_1->id, 'Lagerort1';
$entry = $entries->[2];
my $err1 = @{ $entry->{errors} }[0];
#print "'".$err1."'\n";
is $entry->{object}->description, 'Teil 1002', 'Teil 1002 set';
is $entry->{object}->warehouse_id, $wh2->id, 'Lager2';
is $err1, 'Error: Bin Ort1_von_Lager1 is not from warehouse Lager2','kein Lager von Lager2';
$entry = $entries->[3];
$err1 = @{ $entry->{errors} }[0];
#print "'".$err1."'\n";
is $entry->{object}->description, 'Teil 1003', 'Teil 1003 set';
is $entry->{object}->warehouse_id, $wh2->id, 'Lager2';
is $err1, 'Error: Invalid bin name kein Lagerort','kein Lagerort';

##### add translations
$file = \<<EOL;
partnumber;description;description_EN;notes_EN;description_IT;notes_IT
P1000;Teil 1000;descr EN 1000;notes EN;descr IT 1000;notes IT
P1001;Teil 1001;descr EN 1001;notes EN;descr IT 1001;notes IT
P1002;Teil 1002;descr EN 1002;notes EN;descr IT 1002;notes IT
P1003;Teil 1003;descr EN 1003;notes EN;descr IT 1003;notes IT
EOL
$entries = test_import($file,$settings2);
$entry = $entries->[0];
is $entry->{object}->description, 'Teil 1000', 'Teil 1000 set';
is $entry->{raw_data}->{description_EN},'descr EN 1000','EN set';
is $entry->{raw_data}->{description_IT},'descr IT 1000','IT set';
my $l = @{$entry->{object}->translations}[0];
is $l->translation,'descr EN 1000','EN trans set';
is $l->longdescription, 'notes EN','EN notes set';
$l = @{$entry->{object}->translations}[1];
is $l->translation,'descr IT 1000','IT trans set';
is $l->longdescription, 'notes IT','IT notes set';

##### add customvar
$file = \<<EOL;
partnumber;cvar_mycvar
P1000;das ist der Ring
P1001;nicht der Nibelungen
P1002;sondern vom
P1003;Herr der Ringe
EOL
$entries = test_import($file,$settings2);
$entry = $entries->[0];
is $entry->{object}->partnumber, 'P1000', 'P1000 set';
is $entry->{raw_data}->{cvar_mycvar},'das ist der Ring','CVAR set';
is @{$entry->{object}->custom_variables}[0]->text_value,'das ist der Ring','Cvar mit richtigem Wert';

# set locale to de so we can match abbreviations
$::locale = $old_locale;
##### import part classification
$file = \<<EOL;
partnumber;pclass;description
W1000;WE;Teil 1000
W1001;WV;Teil 1001
D1002;DV;Dienstleistung 1002
D1003;DH;Dienstleistung 1003
EOL
$entries = test_import($file,$settings2);
$entry = $entries->[0];
is $entry->{object}->classification_id, '1', 'W1000 von Klasse Einkauf';
is $entry->{object}->type, 'part', 'W1000 vom Type part';
$entry = $entries->[1];
is $entry->{object}->classification_id, '2', 'W1001 von Klasse Verkauf';
is $entry->{object}->type, 'part', 'W1001 vom Type part';
$entry = $entries->[2];
is $entry->{object}->classification_id, '2', 'D1002 von Klasse Verkauf';
is $entry->{object}->type, 'service', 'D1002 vom Type service';
$entry = $entries->[3];
is $entry->{object}->classification_id, '3', 'D1003 von Klasse Handelsware';
is $entry->{object}->type, 'service', 'D1003 vom Type service';


clear_up(); # remove all data at end of tests

# end of tests


sub clear_up {
  SL::DB::Manager::Part       ->delete_all(all => 1);
  SL::DB::Manager::Pricegroup ->delete_all(all => 1);
  SL::DB::Manager::Price      ->delete_all(all => 1);
  SL::DB::Manager::Translation->delete_all(all => 1);
  SL::DB::Manager::Language   ->delete_all(all => 1);
  SL::DB::Manager::Bin        ->delete_all(all => 1);
  SL::DB::Manager::Warehouse  ->delete_all(all => 1);
  SL::DB::Manager::CustomVariableConfig->delete_all(all => 1);
}


1;

#####
# vim: ft=perl
# set emacs to perl mode
# Local Variables:
# mode: perl
# End:
