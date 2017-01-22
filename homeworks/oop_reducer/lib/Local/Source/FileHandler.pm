package Local::Source::FileHandler;

use strict;
use warnings;
use utf8;
use PerlIO;

use Moose;
extends 'Local::Source::Array';

has 'fh' => ( is => 'ro', isa => 'Str');

sub BUILD {
    my ( $self ) = @_;
    open( my $FILE , '<:perlio', $self -> {fh} ) or die "Problems with file";
    my @output;
    while (my $str = <$FILE>) {
        $output[ $#output + 1] = $str;
    }
    $self -> { array } = \@output;
}

1