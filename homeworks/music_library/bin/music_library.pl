#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::Parse;
use Local::MusicLibrary;
use Local::Reducer;
use DDP;
use feature 'switch';
no warnings 'experimental';

our $VERSION = '1.1';
my $i = 0;

my @arguments;
while (@ARGV) {
    $arguments[$i++] = shift @ARGV;
}

my %keys = make_arg_hash (@arguments);

my @music;

$i = 0;
while (<>) {
    if (/\.\/.+\/\d{4} - .+\/.+\.[\w]+\s?/) {
        $music[$i++] = add_treck($_)
    }
}

my @coloms;
if (defined $keys{colums}) {
    for ($i = 0; defined $keys{colums}[$i]; $i++) {
        $coloms[$i] = $keys{colums}[$i];
    }
}
else { @coloms = ("band","year","album","treck","form"); }
for my $item ("band","year","album","treck","form") {
    if (defined $keys{$item}) {
        @music = reduce_mus($keys{$item},$item,@music);
    }
}

table_out(@coloms,@music);
1;