package SL::DB::Tax;

use strict;

use SL::DB::MetaSetup::Tax;
use SL::DB::Helper::TranslatedAttributes;

__PACKAGE__->meta->initialize;

# Creates get_all, get_all_count, get_all_iterator, delete_all and update_all.
__PACKAGE__->meta->make_manager_class;

1;
