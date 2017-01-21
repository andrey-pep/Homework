package Local::Source::Array;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Source';

sub next {
    my $self = shift;
    return $self -> { array } [ $self -> { pos }++ ]; 
}
1