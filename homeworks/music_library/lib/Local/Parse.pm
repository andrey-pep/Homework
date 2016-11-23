package Local::Parse;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( add_treck );
our @EXPORT = qw( add_treck );

sub add_treck {
    my $source = shift;
    if (/\.\/(.+)\/(\d{4}) - (.+)\/(.+)\.([\w]+)\s?/g) {
        my %hash_out = (band => $1, year =>$2, album => $3, treck => $4, form => $5);
        return \%hash_out;
    }
    1;
}
1