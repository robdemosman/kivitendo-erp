package SL::DB::Manager::ProjectType;

use strict;

use parent qw(SL::DB::Helper::Manager);

use SL::DB::Helper::Paginated;
use SL::DB::Helper::Sorted;

sub object_class { 'SL::DB::ProjectType' }

__PACKAGE__->make_manager_methods;

sub _sort_spec {
  return (
    default       => [ 'position', 1 ],
    columns       => {
      SIMPLE      => 'ALL',
      description => 'lower(project_types.description)',
    });
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

SL::DB::Manager::ProjectType - Manager for models for the 'project_types' table

=head1 SYNOPSIS

This is a standard Rose::DB::Manager based model manager and can be
used as such.

=head1 FUNCTIONS

None yet.

=head1 BUGS

Nothing here yet.

=head1 AUTHOR

Moritz Bunkus E<lt>m.bunkus@linet-services.deE<gt>

=cut
