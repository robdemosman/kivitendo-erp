package SL::DB::Chart;

use strict;

use SL::DB::MetaSetup::Chart;
use SL::DB::Manager::Chart;
use SL::DBUtils;
use Rose::DB::Object::Helpers qw(as_tree);
use SL::DB::Helper::AccountingPeriod qw(get_balance_starting_date);
use SL::Locale::String qw(t8);

__PACKAGE__->meta->add_relationships(taxkeys => { type         => 'one to many',
                                                  class        => 'SL::DB::TaxKey',
                                                  column_map   => { id => 'chart_id' },
                                                },
                                    );

__PACKAGE__->meta->initialize;

sub get_active_taxkey {
  my ($self, $date) = @_;
  $date ||= DateTime->today_local;

  my $cache = $::request->cache("get_active_taxkey")->{$date} //= {};
  return $cache->{$self->id} if $cache->{$self->id};

  require SL::DB::TaxKey;
  return $cache->{$self->id} = SL::DB::Manager::TaxKey->get_all(
    query   => [ and => [ chart_id  => $self->id,
                          startdate => { le => $date } ] ],
    sort_by => "startdate DESC")->[0];
}

sub get_active_taxrate {
  my ($self, $date) = @_;
  $date ||= DateTime->today_local;
  require SL::DB::Tax;
  my $tax = SL::DB::Manager::Tax->find_by( id => $self->get_active_taxkey->tax_id );
  return $tax->rate;
}


sub get_balance {
  my ($self, %params) = @_;

  return undef unless $self->id;

  # return empty string if user doesn't have rights
  return "" unless ($main::auth->assert('general_ledger', 1));

  my $query = qq|SELECT SUM(amount) AS sum FROM acc_trans WHERE chart_id = ? AND transdate >= ? and transdate <= ?|;

  my $fromdate = $params{fromdate} || $::locale->parse_date_to_object($self->get_balance_starting_date);
  my $todate   = $params{todate}   || DateTime->today_local;

  die "get_balance: fromdate and todate arguments must be DateTime Objects" unless ref($fromdate) eq 'DateTime' and ref($todate) eq 'DateTime';

  my ($balance)  = selectfirst_array_query($::form, $self->db->dbh, $query, $self->id, $fromdate, $todate);

  return $balance;
};

sub formatted_balance_dc {
  my ($self, %params) = @_;

  # return empty string if user doesn't have rights
  return "" unless ($main::auth->assert('general_ledger', 1));

  # return empty string if chart has never been booked
  return "" unless $self->has_transaction;

  # return abs of current balance with the abbreviation for debit or credit behind it
  my $balance = $self->get_balance(%params) || 0;
  my $dc_abbreviation = $balance > 0 ? t8("Credit (one letter abbreviation)") : t8("Debit (one letter abbreviation)");
  my $amount = $::form->format_amount(\%::myconfig, abs($balance), 2);

  return "$amount $dc_abbreviation";
};

sub number_of_transactions {
  my ($self) = @_;
  require SL::DB::AccTransaction;
  return SL::DB::Manager::AccTransaction->get_all_count( where => [ chart_id => $self->id ] );
};

sub has_transaction {
  my ($self) = @_;

  $self->db->dbh->selectrow_array('select exists(select 1 from acc_trans where chart_id = ?)', {}, $self->id);
}

sub new_chart_valid {
  my ($self) = @_;

  if ( $self->valid_from && DateTime->today >= $self->valid_from ) {
    return 1;
  } else {
    return 0;
  };
}

sub displayable_name {
  my ($self) = @_;

  return join ' ', grep $_, $self->accno, $self->description;
}

sub displayable_category {
  my ($self) = @_;

  return t8("Account Category E") if $self->category eq "E";
  return t8("Account Category I") if $self->category eq "I";
  return t8("Account Category A") if $self->category eq "A";
  return t8("Account Category L") if $self->category eq "L";
  return t8("Account Category Q") if $self->category eq "Q";
  return t8("Account Category C") if $self->category eq "C";
  return '';
}

sub date_of_last_transaction {
  my ($self) = @_;

  die unless $self->id;

  return '' unless $self->has_transaction;

  my ($transdate) = $self->db->dbh->selectrow_array('select max(transdate) from acc_trans where chart_id = ?', {}, $self->id);
  return DateTime->from_lxoffice($transdate);
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

SL::DB::Chart - Rose database model for the "chart" table

=head1 FUNCTIONS

=over 4

=item C<get_active_taxkey $date>

Returns the active tax key object for a given date. C<$date> defaults
to the current date if undefined.

=item C<get_active_taxrate $date>

Returns the tax rate of the active tax key as determined by
C<get_active_taxkey>.

=item C<get_balance %PARAMS>

Returns the current balance of the chart (sum of amount in acc_trans, positive
or negative). The transactions are filtered by transdate, the maximum date is
the current day, the minimum date is determined by get_balance_starting_date.

The balance should be same as that in the balance report for that chart, with
the asofdate as the current day, and the accounting_method "accrual".

If DateTime objects are passed via the params fromdate and todate, the balance
is calculated only for that period.

=item C<formatted_balance_dc %PARAMS>

Returns a formatted version of C<get_balance>, taking the absolute value and
adding the translated abbreviation for debit or credit after the number.

Any params are passed on to C<get_balance>.

=item C<number_of_transactions>

Returns number of transactions that exist for this chart in acc_trans.

=item C<has_transaction>

Returns 1 or 0, depending whether the chart has a transaction in the database
or not.

=item C<date_of_last_transaction>

Returns the date of the last transaction of the chart in the database, which
may lie in the future.

=item C<new_chart_valid>

Checks whether a follow-up chart is configured, and returns 1 or 0 depending on
whether the valid_from date is before or after the current date.
Is this even used anywhere?

=back

=head1 BUGS

Nothing here yet.

=head1 AUTHOR

Moritz Bunkus E<lt>m.bunkus@linet-services.deE<gt>

G. Richardson E<lt>information@kivitendo-premium.deE<gt>

=cut
