package SL::Layout::CssMenu;

use strict;
use parent qw(SL::Layout::Base);

sub use_stylesheet {
  qw(style.css),
}

sub pre_content {
  $_[0]->presenter->render('menu/menuv3', menu => $_[0]->menu);
}

1;
