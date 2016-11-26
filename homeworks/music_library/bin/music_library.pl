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
    if (/\.\/.+\/\d+ - .+\/.+\.[\w]+\s?/) {
        $music[$i++] = add_treck($_)
    }
}

my @columns;
if (defined $keys{columns}) {
    for ($i = 0; defined $keys{columns}[$i]; $i++) {
        $columns[$i] = $keys{columns}[$i];
    }
}
else {@columns = ("band","year","album","treck","format"); }
for my $item ("band","year","album","treck","format") {
    if (defined $keys{$item}) {
        @music = reduce_mus($keys{$item},$item,@music);
    }
}

@music = sort_mus($keys{sort},@music);

table_out(@columns,@music);
1;