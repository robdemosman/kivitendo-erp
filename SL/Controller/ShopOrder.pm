package SL::Controller::ShopOrder;

use strict;

use parent qw(SL::Controller::Base);

use SL::BackgroundJob::ShopOrderMassTransfer;
use SL::System::TaskServer;
use SL::DB::ShopOrder;
use SL::DB::ShopOrderItem;
use SL::DB::Shop;
use SL::DB::History;
use SL::DBUtils;
use SL::Shop;
use SL::Presenter;
use SL::Helper::Flash;
use SL::Locale::String;
use SL::Controller::Helper::ParseFilter;
use Rose::Object::MakeMethods::Generic
(
  'scalar --get_set_init' => [ qw(shop_order transferred js) ],
);

__PACKAGE__->run_before('setup');

use Data::Dumper;

sub action_get_orders {
  my ( $self ) = @_;
  my $orders_fetched;
  my $active_shops = SL::DB::Manager::Shop->get_all(query => [ obsolete => 0 ]);
  foreach my $shop_config ( @{ $active_shops } ) {
    my $shop = SL::Shop->new( config => $shop_config );
    my $new_orders = $shop->connector->get_new_orders;
#    push @{ $orders_fetched },@{ $new_orders };
  };
#  $main::lxdebug->dump(0, 'WH:OF ',$orders_fetched);

#  flash('info', t8('#1 shoporders has been fetched', scalar(@{$orders_fetched})-1));
  $self->action_list;
}

sub action_list {
  my ( $self ) = @_;
  my %filter = ($::form->{filter} ? parse_filter($::form->{filter}) : query => [ transferred => 0, obsolete => 0 ]);
  my $transferred = $::form->{filter}->{transferred_eq_ignore_empty} ne '' ? $::form->{filter}->{transferred_eq_ignore_empty} : '';
  my $sort_by = $::form->{sort_by} ? $::form->{sort_by} : 'order_date';
  $sort_by .=$::form->{sort_dir} ? ' DESC' : ' ASC';
  my $shop_orders = SL::DB::Manager::ShopOrder->get_all( %filter, sort_by => $sort_by,
                                                      with_objects => ['shop_order_items', 'kivi_customer'],
                                                    );

  foreach my $shop_order(@{ $shop_orders }){

    my $open_invoices = SL::DB::Manager::Invoice->get_all_count(
      query => [customer_id => $shop_order->{kivi_customer_id},
              paid => {lt_sql => 'amount'},
      ],
    );
    $shop_order->{open_invoices} = $open_invoices;
  }
  $self->_setup_list_action_bar;
  $self->render('shop_order/list',
                title       => t8('ShopOrders'),
                SHOPORDERS  => $shop_orders,
                TOOK        => $transferred,
              );
}

sub action_show {
  my ( $self ) = @_;
  my $id = $::form->{id} || {};
  my $shop_order = SL::DB::ShopOrder->new( id => $id )->load( with => ['kivi_customer'] );
  die "can't find shoporder with id $id" unless $shop_order;

  my $proposals = $shop_order->check_for_existing_customers;

  $self->render('shop_order/show',
                title       => t8('Shoporder'),
                IMPORT      => $shop_order,
                PROPOSALS   => $proposals,
              );

}

sub action_delete_order {
  my ( $self ) = @_;

  $self->shop_order->obsolete(1);
  $self->shop_order->save;
  $self->redirect_to(controller => "ShopOrder", action => 'list', filter => { 'transferred:eq_ignore_empty' => 0 });
}

sub action_undelete_order {
  my ( $self ) = @_;

  $self->shop_order->obsolete(0);
  $self->shop_order->save;
  $self->redirect_to(controller => "ShopOrder", action => 'show', id => $self->shop_order->id);
}

sub action_transfer {
  my ( $self ) = @_;
  my $customer = SL::DB::Manager::Customer->find_by(id => $::form->{customer});
  die "Can't find customer" unless $customer;
  my $employee = SL::DB::Manager::Employee->current;

  die "Can't load shop_order form form->import_id" unless $self->shop_order;

  my $order = $self->shop_order->convert_to_sales_order(customer => $customer, employee => $employee);
  ## price_tax_calculator
  if ($order->{error}){
    flash_later('error',@{$order->{errors}});
  $self->redirect_to(controller => "ShopOrder", action => 'show', id => $self->shop_order->id);
  }else{
    $order->save;

    my $snumbers = "ordernumber_" . $order->ordnumber;
    SL::DB::History->new(
                      trans_id    => $order->id,
                      snumbers    => $snumbers,
                      employee_id => SL::DB::Manager::Employee->current->id,
                      addition    => 'SAVED',
                      what_done   => 'Shopimport -> Order',
                    )->save();
    foreach my $item(@{ $order->orderitems }){
      $item->parse_custom_variable_values->save;
      $item->{custom_variables} = \@{ $item->cvars_by_config };
      $item->save;
    }

    $self->shop_order->transferred(1);
    $self->shop_order->transfer_date(DateTime->now_local);
    $self->shop_order->oe_transid($order->id);
    $self->shop_order->save;
    $self->shop_order->link_to_record($order);
    $self->redirect_to(controller => "oe.pl", action => 'edit', type => 'sales_order', vc => 'customer', id => $order->id);
  }
}

sub action_mass_transfer {
  my ($self) = @_;
  my @shop_orders =  @{ $::form->{id} || [] };

  my $job                   = SL::DB::BackgroundJob->new(
    type                    => 'once',
    active                  => 1,
    package_name            => 'ShopOrderMassTransfer',
  )->set_data(
     shop_order_record_ids       => [ @shop_orders ],
     num_order_created           => 0,
     num_delivery_order_created  => 0,
     status                      => SL::BackgroundJob::ShopOrderMassTransfer->WAITING_FOR_EXECUTION(),
     conversion_errors         => [ ],
   )->update_next_run_at;

   SL::System::TaskServer->new->wake_up;

   my $html = $self->render('shop_order/_transfer_status', { output => 0 }, job => $job);

   $self->js
      ->html('#status_mass_transfer', $html)
      ->run('kivi.ShopOrder.massTransferStarted')
      ->render;
}

sub action_transfer_status {
  my ($self)  = @_;
  my $job     = SL::DB::BackgroundJob->new(id => $::form->{job_id})->load;
  my $html    = $self->render('shop_order/_transfer_status', { output => 0 }, job => $job);

  $self->js->html('#status_mass_transfer', $html);
  $self->js->run('kivi.ShopOrder.massTransferFinished') if $job->data_as_hash->{status} == SL::BackgroundJob::ShopOrderMassTransfer->DONE();
  $self->js->render;

}

sub action_apply_customer {
  my ( $self, %params ) = @_;
  my $shop = SL::DB::Manager::Shop->find_by( id => $self->shop_order->shop_id );
  my $what = $::form->{create_customer}; # new from billing, customer or delivery address
  my %address = ( 'name'                  => $::form->{$what.'_name'},
                  'department_1'          => $::form->{$what.'_company'},
                  'department_2'          => $::form->{$what.'_department'},
                  'street'                => $::form->{$what.'_street'},
                  'zipcode'               => $::form->{$what.'_zipcode'},
                  'city'                  => $::form->{$what.'_city'},
                  'email'                 => $::form->{$what.'_email'},
                  'country'               => $::form->{$what.'_country'},
                  'phone'                 => $::form->{$what.'_phone'},
                  'email'                 => $::form->{$what.'_email'},
                  'greeting'              => $::form->{$what.'_greeting'},
                  # TODO in shopconfig
                        'taxincluded_checked'   => $shop->pricetype eq "brutto" ? 1 : 0,
                        'taxincluded'           => $shop->pricetype eq "brutto" ? 1 : 0,
                        'pricegroup_id'         => (split '\/',$shop->price_source)[0] eq "pricegroup" ?  (split '\/',$shop->price_source)[1] : undef,
                        'taxzone_id'            => $shop->taxzone_id,
                        'currency'              => 1,   # TODO hardcoded
                        #'payment_id'            => 7345,# TODO hardcoded
                );
  my $customer;
  if($::form->{cv_id}){
    $customer = SL::DB::Customer->new(id => $::form->{cv_id})->load;
    $customer->assign_attributes(%address);
    $customer->save;
  }else{
    $customer = SL::DB::Customer->new(%address);
    $customer->save;
  }
  my $snumbers = "customernumber_" . $customer->customernumber;
  SL::DB::History->new(
                    trans_id    => $customer->id,
                    snumbers    => $snumbers,
                    employee_id => SL::DB::Manager::Employee->current->id,
                    addition    => 'SAVED',
                    what_done   => 'Shopimport',
                  )->save();

  if($::form->{$what.'_country'} ne "Deutschland") {   # hardcoded
    $self->redirect_to(controller => "controller.pl", action => 'CustomerVendor/edit', id => $customer->id);
  }else{
    $self->redirect_to(action => 'show', id => $::form->{import_id});
  }
}

sub setup {
  my ($self) = @_;
  $::auth->assert('invoice_edit');

  $::request->layout->use_javascript("${_}.js")  for qw(kivi.ShopOrder);
}

#
# Helper
#
sub check_address {
  my ($self,%address) = @_;
  my $addressdata = SL::DB::Manager::Customer->get_all(
                                query => [
                                            or => [ 'name'   => { ilike => "%$address{'name'}%" }, 'name' => { ilike => $address{'company'} }, ],
                                           'street' => { ilike => $address{'street'} },
                                           'zipcode'=> { ilike => $address{'zipcode'} },
                                           'city'   => { ilike => $address{'city'} },
                                         ]);
  return @{$addressdata}[0];
}

sub init_shop_order {
  my ( $self ) = @_;
  return SL::DB::ShopOrder->new(id => $::form->{import_id})->load if $::form->{import_id};
}

sub init_transferred {
  # data for drop down filter options

  [ { title => t8("all"),             value => '' },
    { title => t8("transferred"),     value => 1  },
    { title => t8("not transferred"), value => 0  }, ]
}

sub _setup_list_action_bar {
  my ($self) = @_;

  for my $bar ($::request->layout->get('actionbar')) {
    $bar->add(
        action => [
          t8('Search'),
          submit    => [ '#shoporders', { action => "ShopOrder/list" } ],
        ],
         link => [
          t8('Shoporders'),
          link => [ $self->url_for(action => 'get_orders') ],
          tooltip => t8('New shop orders'),
        ],
        'separator',
        action => [
          t8('Apply'),
          call => [ 'kivi.ShopOrder.setup', id => "mass_transfer" ],
          tooltip => t8('Transfer all marked'),
        ],
    );
  }
}

1;

__END__

=encoding utf-8

=head1 NAME

  SL::Controller::ShopOrder - Handles th imported shoporders

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 BUGS

  None yet. :)

=head1 AUTHOR

  W. Hahn E<lt>wh@futureworldsearch.netE<gt>

=cut
