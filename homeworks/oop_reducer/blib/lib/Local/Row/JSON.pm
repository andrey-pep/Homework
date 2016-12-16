package Local::Row::JSON;

use strict;
use warnings;
use utf8;
use parent 'Local::Row';
use JSON::XS;

sub parse {
    my ($self,$source) = @_;
    return JSON::XS->new->decode($source);
}
1