package Local::Source;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, %array) = @_;
    $array{pos} = 0;
    return bless \%array, $class;   
}
1