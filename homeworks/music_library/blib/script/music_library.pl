#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::Parse;
use Local::MusicLibrary;
use Local::KeyWork;
no warnings 'experimental';
use feature 'say';
use Getopt::Long;

our $VERSION = '1.2';
my $i = 0;

my %keys = ();

GetOptions( \%keys,
    "band=s",
    "year=s",
    "album=s",
    "track=s",
    "format=s",
    "sort=s",
    "columns=s" );

my @music;

$i = 0;

while (<>) {
    if (/\.\/([\s\w\-]+)\/(\d+) - ([\s\w\-]+)\/([\s\w\-]+)\.(\w+)\s?$/g) {
        $music[$i++] = add_treck($1,$2,$3,$4,$5)
    }
}

my @columns;

if (defined $keys{columns}) {
    @columns = split (/,/, $keys{columns});
}
else {@columns = ("band","year","album","track","format"); }

for my $item ("band","year","album","track","format") {
    if (defined $keys{$item}) {
        @music = reduce_mus($keys{$item},$item,@music);
    }
}

if (defined $keys{sort}) {
    @music = sort_mus($keys{sort},@music);
}

table_out(\@columns,\@music);
1;