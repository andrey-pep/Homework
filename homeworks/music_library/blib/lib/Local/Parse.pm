package Local::Parse;

use strict;
use warnings;
use 5.010;
use base qw(Exporter);
our @EXPORT_OK = qw( add_treck make_arg_hash);
our @EXPORT = qw( add_treck make_arg_hash);
use DDP;
our $VERSION = '1.2';
my $i = 0;

sub add_track {
        my $source = shift;
        if ( $$source =~ /\.\/(?<band>[\s\w\-]+)\/(?<year>\d+) - (?<album>[\s\w\-]+)\/(?<track>[\s\w\-]+)\.(?<format>\w+)\s?$/g) {
        my %hash = ("band"   => $+{band},
                   "year"   => $+{year},
                   "album"  => $+{album},
                   "track"  => $+{track},
                   "format" => $+{format} );
        my $music = shift;
        $$music[ @#$music + 1 ] = \%hash;
        }
}
1