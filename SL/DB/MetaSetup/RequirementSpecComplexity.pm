# This file has been auto-generated. Do not modify it; it will be overwritten
# by rose_auto_create_model.pl automatically.
package SL::DB::RequirementSpecComplexity;

use strict;

use parent qw(SL::DB::Object);

__PACKAGE__->meta->table('requirement_spec_complexities');

__PACKAGE__->meta->columns(
  description => { type => 'text', not_null => 1 },
  id          => { type => 'serial', not_null => 1 },
  itime       => { type => 'timestamp', default => 'now()' },
  mtime       => { type => 'timestamp' },
  position    => { type => 'integer', not_null => 1 },
);

__PACKAGE__->meta->primary_key_columns([ 'id' ]);

__PACKAGE__->meta->unique_keys([ 'description' ]);

__PACKAGE__->meta->allow_inline_column_values(1);

1;
;
