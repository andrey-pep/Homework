package Local::Source;
use strict;
use warnings;
use utf8;
use Moose;

has 'array' => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1, builder => '_build_array' );
has 'pos' => ( is => 'rw', isa => 'Int',  default => 0 );

sub _build_array {
    my ( $self, $source ) = @_;
    return $source;
}

1