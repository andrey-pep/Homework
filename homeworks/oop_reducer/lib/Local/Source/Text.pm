package Local::Source::Text;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Source::Array';

has 'delimiter' => ( is => 'ro', isa => 'Str', default => "\n" );
has 'text' => ( is => 'ro', isa => 'Str');

sub BUILD {
    my ( $self ) = @_;
    my $delim = $self -> { delimiter };
    my @array =  split ( $delim, $self -> { text } );
    $self -> {array} = \@array;
}

1
