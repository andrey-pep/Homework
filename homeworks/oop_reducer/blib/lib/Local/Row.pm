package Local::Row;
use strict;
use warnings;
use utf8;
use Moose;

has 'str' => ( is => 'rw', isa => 'Str', builder => '_build_str' );

sub _build_str {
    return 42;
}

sub get {
    my ($self, $name, $default) = @_;
    if ( defined $self -> { str } -> { $name } ) { return $self -> { str } -> { $name }; }
    else { return $default; }
}
1