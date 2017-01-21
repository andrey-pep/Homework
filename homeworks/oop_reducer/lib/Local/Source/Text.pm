package Local::Source::Text;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Source::Array';


has 'delimiter' => ( is => 'rw', isa => 'Str', default => "\n" );
has 'text' => ( is => 'rw', isa => 'Str');

sub _build_array {
    my ( $self ) = @_;
    my $delim = $self -> { delimiter };
    my @array =  split ( $delim, $self -> { text } );
    return \@array;
}

1
