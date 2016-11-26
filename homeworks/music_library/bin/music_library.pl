#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::Parse;
use Local::MusicLibrary;
use Local::KeyWork;
no warnings 'experimental';
use utf8;

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
    if (/\.\/(.+)\/(\d+) - (.+)\/(.+)\.([\w]+)\s?/g) {
        $music[$i++] = add_treck($1,$2,$3,$4,$5)
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

if (defined $keys{sort}) {
    @music = sort_mus($keys{sort},@music);
}

table_out(@columns,@music);
1;