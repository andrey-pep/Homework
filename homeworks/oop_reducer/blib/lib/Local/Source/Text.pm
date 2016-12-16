package Local::Source::Text;

use strict;
use warnings;
use utf8;
use parent 'Local::Source::Array';

sub new {
    my ($class, %params) = @_;
    my $delim = $params{delimiter} ? $params{delimiter} : '\n';
    return $class -> SUPER::new( array => [ split ( $delim, $params{text} ) ] );
}
1