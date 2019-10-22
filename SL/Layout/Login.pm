package SL::Layout::Login;

use strict;
use parent qw(SL::Layout::None);

sub start_content {
  "<div id='login' class='login'>\n";
}

sub end_content {
  "</div>\n";
}

1;
