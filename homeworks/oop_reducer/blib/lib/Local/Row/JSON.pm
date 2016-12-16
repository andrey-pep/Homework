package Local::Row::JSON;

use strict;
use warnings;
use utf8;
use parent 'Local::Row';
use JSON::XS;

sub parse {
    my ($self,$source) = @_;
    my $out = JSON::XS->new->decode($source);
    return $out;
}
1