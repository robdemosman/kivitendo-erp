# This file has been auto-generated only because it didn't exist.
# Feel free to modify it at will; it will not be overwritten automatically.

package SL::DB::AssortmentItem;

use strict;

use SL::DB::MetaSetup::AssortmentItem;
use SL::DB::Manager::AssortmentItem;
use Rose::DB::Object::Helpers qw(clone);

__PACKAGE__->meta->initialize;

sub linetotal_sellprice {
  my ($self, %params) = @_;

  my $sellprice = $self->part->sellprice;
  if ($params{pricegroup}) {
    my $pricegroup = SL::DB::Manager::Pricegroup->find_by( pricegroup => $params{pricegroup});
    die "Can't find pricegroup with name " . $params{pricegroup} unless $pricegroup;
    $params{pricegroup_id} = $pricegroup->id if $pricegroup;
  }
  if ($params{pricegroup_id}) {
    my $price = SL::DB::Manager::Price->find_by(pricegroup_id => $params{pricegroup_id}, parts_id => $self->part->id);
    $sellprice = $price->price if $price;
  }

  return 0 unless $self->qty > 0 and $sellprice > 0;
  return $self->qty * $sellprice / ( $self->part->price_factor_id ? $self->part->price_factor->factor : 1 );
}

sub linetotal_lastcost {
  my ($self) = @_;

  return 0 unless $self->qty > 0 and $self->part->lastcost > 0;
  return $self->qty * $self->part->lastcost / ( $self->part->price_factor_id ? $self->part->price_factor->factor : 1 );
}

1;
