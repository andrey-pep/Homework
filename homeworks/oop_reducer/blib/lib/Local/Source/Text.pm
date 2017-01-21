package Local::Source::Text;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Source::Array';

has 'delimiter' => ( is => 'rw', isa => 'Str', default => "\n" );
has 'text' => (
    is => 'rw',
    isa => 'Str',
    default => sub {
        my ($self) = @_;
        my $delim = $self -> { delimiter };
        return $self -> SUPER::new( array => [ split ( $delim, $self -> { text } ) ] );
    }
);

1
