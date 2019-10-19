package SL::DefaultManager::Nederlands;

use strict;
use parent qw(Rose::Object);

# client defaults
sub chart_of_accounts       { 'Nederlands-Rekeningstelsel' }
sub accounting_method       { 'accrual' }
sub inventory_system        { 'periodic' }
sub profit_determination    { 'balance' }
sub currency                { 'EUR' }
sub precision               { 0.01 }
sub feature_balance         { 1 }
sub feature_datev           { 0 }
sub feature_erfolgsrechnung { 1 }
sub feature_eurechnung      { 0 }
sub feature_ustva           { 0 }
sub feature_btw             { 1 }

# user defaults
sub numberformat            { "1000,00" }
sub dateformat              { 'dd-mm-yy' }
sub timeformat              { 'hh:mm' }

# default for login/admin areas
sub country                 { 'NL' }
sub language                { 'nl' }

1;
