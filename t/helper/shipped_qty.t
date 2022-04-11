use strict;
use Test::More;

use lib 't';
use Support::TestSetup;
use Carp;
use Test::Exception;
use Data::Dumper;
use SL::DB::Part;
use SL::DB::Inventory;
use SL::DB::TransferType;
use SL::DB::Order;
use SL::DB::DeliveryOrder;
use SL::DB::Customer;
use SL::DB::Vendor;
use SL::DB::RecordLink;
use SL::DB::DeliveryOrderItemsStock;
use SL::DB::Bin;
use SL::WH;
use SL::AM;
use SL::Dev::ALL qw(:ALL);
use SL::Helper::ShippedQty;
use DateTime;

Support::TestSetup::login();

clear_up();

my ($customer, $vendor, @parts, $unit);

$customer = new_customer(name => 'Testkunde'    )->save;
$vendor   = new_vendor(  name => 'Testlieferant')->save;

my $default_sellprice = 10;
my $default_lastcost  =  4;

my ($wh) = create_warehouse_and_bins();
my $bin1 = SL::DB::Manager::Bin->find_by(description => "Bin 1");
my $bin2 = SL::DB::Manager::Bin->find_by(description => "Bin 2");

my %part_defaults = (
    sellprice    => $default_sellprice,
    warehouse_id => $wh->id,
    bin_id       => $bin1->id
);

# create 3 parts to be used in test
for my $i ( 1 .. 4 ) {
  new_part( %part_defaults, partnumber => $i, description => "part $i test" )->save;
};

my $part1 = SL::DB::Manager::Part->find_by( partnumber => '1' ) or die;
my $part2 = SL::DB::Manager::Part->find_by( partnumber => '2' ) or die;
my $part3 = SL::DB::Manager::Part->find_by( partnumber => '3' ) or die;
my $part4 = SL::DB::Manager::Part->find_by( partnumber => '4' ) or die;

my @part_ids; # list of all part_ids to run checks against
push( @part_ids, $_->id ) foreach ( $part1, $part2, $part3, $part4 );
my %default_transfer_params = ( wh => $wh, bin => $bin1, unit => 'Stck');


# test purchases first, so there is actually stock available when sales is tested

note("testing purchases, no fill_up");

$::form->{type} = 'purchase_order';
my $purchase_order = create_purchase_order(
  save       => 1,
  orderitems => [ create_order_item(part => $part1, qty => 11),
                  create_order_item(part => $part2, qty => 12),
                  create_order_item(part => $part3, qty => 13),
                ]
);

Rose::DB::Object::Helpers::forget_related($purchase_order, 'orderitems');
$purchase_order->orderitems;

local $::instance_conf->data->{shipped_qty_require_stock_out} = 1;
SL::Helper::ShippedQty
  ->new(require_stock_out => 1)  # should make no difference while there is no delivery order
  ->calculate($purchase_order)
  ->write_to_objects;

is($purchase_order->items_sorted->[0]->{shipped_qty}, 0, "first purchase orderitem has no shipped_qty");
ok(!$purchase_order->items_sorted->[0]->{delivered},     "first purchase orderitem is not delivered");

my $purchase_orderitem_part1 = SL::DB::Manager::OrderItem->find_by( parts_id => $part1->id, trans_id => $purchase_order->id);

is($purchase_orderitem_part1->shipped_qty, 0, "OrderItem shipped_qty method ok");

is($purchase_order->closed,     0, 'purchase order is open');
# set delivered only if the do is also stocked in
ok(!$purchase_order->delivered,    'purchase order is not delivered');

note('converting purchase order to delivery order');
# create purchase delivery order from purchase order
my $purchase_delivery_order = $purchase_order->convert_to_delivery_order;
is($purchase_order->closed,    0, 'purchase order is open');
note('purchase order is not general now delivered');
ok(!$purchase_order->delivered,   'purchase order is not delivered');

SL::Helper::ShippedQty
  ->new(require_stock_out => 0)
  ->calculate($purchase_order)
  ->write_to_objects;

is($purchase_order->items_sorted->[0]->{shipped_qty}, 11, "require_stock_out => 0: first purchase orderitem has shipped_qty");
ok($purchase_order->items_sorted->[0]->{delivered},       "require_stock_out => 0: first purchase orderitem is delivered");

Rose::DB::Object::Helpers::forget_related($purchase_order, 'orderitems');
$purchase_order->orderitems;

SL::Helper::ShippedQty
  ->new(require_stock_out => 1)
  ->calculate($purchase_order)
  ->write_to_objects;

is($purchase_order->items_sorted->[0]->{shipped_qty}, 0,  "require_stock_out => 1: first purchase orderitem has no shipped_qty");
ok(!$purchase_order->items_sorted->[0]->{delivered},      "require_stock_out => 1: first purchase orderitem is not delivered");

# ship items from delivery order
transfer_purchase_delivery_order($purchase_delivery_order);

Rose::DB::Object::Helpers::forget_related($purchase_order, 'orderitems');
$purchase_order->orderitems;

SL::Helper::ShippedQty
  ->new(require_stock_out => 1, keep_matches => 1)  # shouldn't make a difference now after shipping
  ->calculate($purchase_order)
  ->write_to_objects;

is($purchase_order->items_sorted->[0]->{shipped_qty}, 11, "require_stock_out => 1: first purchase orderitem has shipped_qty");
ok($purchase_order->items_sorted->[0]->{delivered},       "require_stock_out => 1: first purchase orderitem is delivered");

my $purchase_orderitem_part2 = SL::DB::Manager::OrderItem->find_by(parts_id => $part1->id, trans_id => $purchase_order->id);

is($purchase_orderitem_part2->shipped_qty(require_stock_out => 1), 11, "OrderItem shipped_qty from helper ok");


note('testing sales, no fill_up');

$::form->{type} = 'sales_order';
my $sales_order = create_sales_order(
  save       => 1,
  orderitems => [ create_order_item(part => $part1, qty => 5),
                  create_order_item(part => $part2, qty => 6),
                  create_order_item(part => $part3, qty => 7),
                ]
);

Rose::DB::Object::Helpers::forget_related($sales_order, 'orderitems');
$sales_order->orderitems;

SL::Helper::ShippedQty
  ->new(require_stock_out => 1)  # should make no difference while there is no delivery order
  ->calculate($sales_order)
  ->write_to_objects;

is($sales_order->items_sorted->[0]->{shipped_qty}, 0,  "first sales orderitem has no shipped_qty");
ok(!$sales_order->items_sorted->[0]->{delivered},      "first sales orderitem is not delivered");

my $orderitem_part1 = SL::DB::Manager::OrderItem->find_by(parts_id => $part1->id, trans_id => $sales_order->id);
my $orderitem_part2 = SL::DB::Manager::OrderItem->find_by(parts_id => $part2->id, trans_id => $sales_order->id);

is($orderitem_part1->shipped_qty, 0, "OrderItem shipped_qty method ok");

# create sales delivery order from sales order
my $sales_delivery_order = $sales_order->convert_to_delivery_order;

SL::Helper::ShippedQty
  ->new(require_stock_out => 0)
  ->calculate($sales_order)
  ->write_to_objects;

is($sales_order->items_sorted->[0]->{shipped_qty}, 5, "require_stock_out => 0: first sales orderitem has shipped_qty");
ok($sales_order->items_sorted->[0]->{delivered},      "require_stock_out => 0: first sales orderitem is delivered");

Rose::DB::Object::Helpers::forget_related($sales_order, 'orderitems');
$sales_order->orderitems;

SL::Helper::ShippedQty
  ->new(require_stock_out => 1)
  ->calculate($sales_order)
  ->write_to_objects;

is($sales_order->items_sorted->[0]->{shipped_qty}, 0,  "require_stock_out => 1: first sales orderitem has no shipped_qty");
ok(!$sales_order->items_sorted->[0]->{delivered},      "require_stock_out => 1: first sales orderitem is not delivered");

# ship items from delivery order
transfer_sales_delivery_order($sales_delivery_order);

Rose::DB::Object::Helpers::forget_related($sales_order, 'orderitems');
$sales_order->orderitems;

SL::Helper::ShippedQty
  ->new(require_stock_out => 1)
  ->calculate($sales_order)
  ->write_to_objects;

is($sales_order->items_sorted->[0]->{shipped_qty}, 5, "require_stock_out => 1: first sales orderitem has no shipped_qty");
ok($sales_order->items_sorted->[0]->{delivered},      "require_stock_out => 1: first sales orderitem is not delivered");

$orderitem_part1 = SL::DB::Manager::OrderItem->find_by(parts_id => $part1->id, trans_id => $sales_order->id);

is($orderitem_part1->shipped_qty(require_stock_out => 1), 5, "OrderItem shipped_qty from helper ok");


note('misc tests');
my $number_of_linked_items = SL::DB::Manager::RecordLink->get_all_count( where => [ from_table => 'orderitems', to_table => 'delivery_order_items' ] );
is ($number_of_linked_items , 6, "6 record_links for items, 3 from sales order, 3 from purchase order");

note('testing optional orderitems');

my $item_optional = create_order_item(part => $part3, qty => 7, optional => 1);
ok($item_optional->{optional},       "optional order item");

my $sales_order_opt = create_sales_order(
  save       => 1,
  orderitems => [ create_order_item(part => $part1, qty => 5),
                  create_order_item(part => $part2, qty => 6),
                  $item_optional,
                ]
);


SL::Helper::ShippedQty
  ->new(require_stock_out => 1)  # should make no difference while there is no delivery order
  ->calculate($sales_order_opt)
  ->write_to_objects;

is($sales_order_opt->items_sorted->[2]->{shipped_qty}, 0,  "third optional sales orderitem has no shipped_qty");
ok(!$sales_order_opt->items_sorted->[2]->{delivered},      "third optional sales orderitem is not delivered");
ok($sales_order_opt->items_sorted->[2]->{optional},        "third optional sales orderitem is optional");

my $orderitem_part3_opt = SL::DB::Manager::OrderItem->find_by(parts_id => $part3->id, trans_id => $sales_order_opt->id);
is($orderitem_part3_opt->shipped_qty, 0, "OrderItem shipped_qty method ok");

# create sales delivery order from sales order
my $sales_delivery_order_opt = $sales_order_opt->convert_to_delivery_order;
is(scalar @{ $sales_delivery_order_opt->items_sorted }, 3,   "third optional sales delivery orderitem is there");

# and delete third item
my $optional =  SL::DB::Manager::DeliveryOrderItem->find_by(parts_id => $part3->id, delivery_order_id => $sales_delivery_order_opt->id);
SL::DB::DeliveryOrderItem->new(id => $optional->id)->delete;
$sales_delivery_order_opt->save(cascade => 1);
my $new_sales_delivery_order_opt = SL::DB::Manager::DeliveryOrder->find_by(id => $sales_delivery_order_opt->id);
is(scalar @{ $new_sales_delivery_order_opt->items_sorted }, 2,   "third optional sales delivery orderitem is undef");

SL::Helper::ShippedQty
  ->new(require_stock_out => 0)
  ->calculate($sales_order_opt)
  ->write_to_objects;

is($sales_order_opt->items_sorted->[0]->{shipped_qty}, 5,  "require_stock_out => 0: first sales orderitem has shipped_qty");
ok($sales_order_opt->items_sorted->[0]->{delivered},       "require_stock_out => 0: first sales orderitem is delivered");
ok($sales_order_opt->items_sorted->[1]->{delivered},       "require_stock_out => 0: second sales orderitem is delivered");
ok(!$sales_order_opt->items_sorted->[2]->{delivered},      "require_stock_out => 0: third sales orderitem is NOT delivered");
is($sales_order_opt->items_sorted->[2]->{shipped_qty}, 0,  "require_stock_out => 0: third sales orderitem has no shipped_qty");
ok($sales_order_opt->{delivered},                          "require_stock_out => 0: order IS delivered");

clear_up();

{
# edge case:
#
# suppose an order was delivered, and someone removes one item from the delivery order.
# make sure the order is then shown as not delivered.
#
  my $sales_order = create_sales_order(
    save       => 1,
    orderitems => [ create_order_item(part => new_part()->save, qty => 5),
                    create_order_item(part => new_part()->save, qty => 6),
                    create_order_item(part => new_part()->save, qty => 7),
                  ]
  );
  $sales_order->load;

  my $delivery_order = SL::DB::DeliveryOrder->new_from($sales_order);
  $delivery_order->save;

  $delivery_order->items(@{ $delivery_order->items_sorted }[0..1]);
  $delivery_order->save;

  SL::Helper::ShippedQty
    ->new(require_stock_out => 0)
    ->calculate($sales_order)
    ->write_to_objects;

  ok !$sales_order->delivered, 'after deleting a position from a delivery order, the order is undelivered again';
}

clear_up();

done_testing;

sub clear_up {
  foreach ( qw(Inventory DeliveryOrderItem DeliveryOrder Price OrderItem Order Part Customer Vendor Bin Warehouse) ) {
    "SL::DB::Manager::${_}"->delete_all(all => 1);
  }
};
