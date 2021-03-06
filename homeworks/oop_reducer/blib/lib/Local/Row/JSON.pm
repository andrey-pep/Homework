package Local::Row::JSON;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Row';
use JSON::XS;

sub _build_tmp {
    my ($self) = @_;
    my $source = $self -> str;
    my $out = JSON::XS->new->decode($source);
    return $out;
}
1