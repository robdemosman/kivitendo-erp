package SL::Presenter::DeliveryOrder;

use strict;

use SL::DB::DeliveryOrder::TypeData ();
use SL::Locale::String qw(t8);
use SL::Presenter::EscapedText qw(escape is_escaped);

use Exporter qw(import);
our @EXPORT_OK = qw(sales_delivery_order purchase_delivery_order delivery_order_status_line);

use Carp;

sub sales_delivery_order {
  my ($delivery_order, %params) = @_;

  return _do_record($delivery_order, 'sales_delivery_order', %params);
}

sub rma_delivery_order {
  my ($delivery_order, %params) = @_;

  return _do_new_record($delivery_order, 'rma_delivery_order', %params);
}

sub purchase_delivery_order {
  my ($delivery_order, %params) = @_;

  return _do_record($delivery_order, 'purchase_delivery_order', %params);
}

sub supplier_delivery_order {
  my ($delivery_order, %params) = @_;

  return _do_new_record($delivery_order, 'supplier_delivery_order', %params);
}

sub _do_new_record {
  my ($delivery_order, $type, %params) = @_;

  $params{display} ||= 'inline';

  croak "Unknown display type '$params{display}'" unless $params{display} =~ m/^(?:inline|table-cell)$/;

  my $text = join '', (
    $params{no_link} ? '' : '<a href="contoller.pl?action=DeliveryOrder/edit&amp;type=' . $type . '&amp;id=' . escape($delivery_order->id) . '">',
    escape($delivery_order->donumber),
    $params{no_link} ? '' : '</a>',
  );
  is_escaped($text);
}

sub _do_record {
  my ($delivery_order, $type, %params) = @_;

  $params{display} ||= 'inline';

  croak "Unknown display type '$params{display}'" unless $params{display} =~ m/^(?:inline|table-cell)$/;

  my $text = join '', (
    $params{no_link} ? '' : '<a href="do.pl?action=edit&amp;type=' . $type . '&amp;id=' . escape($delivery_order->id) . '">',
    escape($delivery_order->donumber),
    $params{no_link} ? '' : '</a>',
  );
  is_escaped($text);
}

sub stock_status {
  my ($delivery_order) = @_;

  my $in_out = SL::DB::DeliveryOrder::TypeData::get3($delivery_order->type, "properties", "transfer");

  if ($in_out eq 'in') {
    return escape($delivery_order->delivered ? t8('transferred in') : t8('not transferred in yet'));
  }

  if ($in_out eq 'out') {
    return escape($delivery_order->delivered ? t8('transferred out') : t8('not transferred out yet'));
  }
}

sub closed_status {
  my ($delivery_order) = @_;

  return escape($delivery_order->closed ? t8('Closed') : t8('Open'))
}

sub status_line {
  my ($delivery_order) = @_;

  return "" unless $delivery_order->id;

  stock_status($delivery_order) . " ; " . closed_status($delivery_order)
}

sub delivery_order_status_line { goto &status_line };

1;

__END__

=pod

=encoding utf8

=head1 NAME

SL::Presenter::DeliveryOrder - Presenter module for Rose::DB objects
for sales and purchase delivery orders

=head1 SYNOPSIS

  # Sales delivery orders:
  my $object = SL::DB::Manager::DeliveryOrder->get_first(where => [ is_sales => 1 ]);
  my $html   = SL::Presenter::DeliveryOrder::sales_delivery_order($object, display => 'inline');

  # Purchase delivery orders:
  my $object = SL::DB::Manager::DeliveryOrder->get_first(where => [ or => [ is_sales => undef, is_sales => 0 ]]);
  my $html   = SL::Presenter::DeliveryOrder::purchase_delivery_order($object, display => 'inline');

=head1 FUNCTIONS

=over 4

=item C<sales_delivery_order $object, %params>

Returns a rendered version (actually an instance of
L<SL::Presenter::EscapedText>) of the sales delivery order object
C<$object>.

C<%params> can include:

=over 2

=item * display

Either C<inline> (the default) or C<table-cell>. At the moment both
representations are identical and produce the objects's delivery
order number linked to the corresponding 'edit' action.

=item * no_link

If falsish (the default) then the delivery order number will be linked
to the "edit delivery order" dialog from the sales menu.

=back

=item C<purchase_delivery_order $object, %params>

Returns a rendered version (actually an instance of
L<SL::Presenter::EscapedText>) of the purchase delivery order object
C<$object>.

C<%params> can include:

=over 2

=item * display

Either C<inline> (the default) or C<table-cell>. At the moment both
representations are identical and produce the objects's delivery
order number linked to the corresponding 'edit' action.

=item * no_link

If falsish (the default) then the delivery order number will be linked
to the "edit delivery order" dialog from the purchase menu.

=back

=back

=head1 BUGS

Nothing here yet.

=head1 AUTHOR

Moritz Bunkus E<lt>m.bunkus@linet-services.deE<gt>

=cut
