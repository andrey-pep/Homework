package Local::Row;
use strict;
use warnings;
use utf8;
use Moose;

has 'str' => ( is => 'ro', isa => 'Str');
has 'tmp' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_tmp' );

sub _build_tmp {
    return 42;
}

sub get {
    my ($self, $name, $default) = @_;
    if ( defined $self -> tmp -> { $name } ) { return $self -> tmp -> { $name }; }
    else { return $default; }
}
1