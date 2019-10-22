package SL::X;

use strict;
use warnings;

use SL::X::Base;

use Exception::Class (
  'SL::X::FormError'    => {
    isa                 => 'SL::X::Base',
  },
  'SL::X::DBError'      => {
    isa                 => 'SL::X::Base',
    fields              => [ qw(msg db_error) ],
    defaults            => { error_template => [ '%s: %s', qw(msg db_error) ] },
  },
  'SL::X::DBHookError'  => {
    isa                 => 'SL::X::DBError',
    fields              => [ qw(when hook object object_type) ],
    defaults            => { error_template => [ '%s hook \'%s\' for object type \'%s\' failed', qw(when hook object_type object) ] },
  },
  'SL::X::DBRoseError'  => {
    isa                 => 'SL::X::DBError',
    fields              => [ qw(class metaobject object) ],
    defaults            => { error_template => [ '\'%s\' in object of type \'%s\' occured', qw(db_error class) ] },
  },
  'SL::X::DBUtilsError' => {
    isa                 => 'SL::X::DBError',
  },
);

1;
