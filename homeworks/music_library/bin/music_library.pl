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

our $VERSION = '1.00';
my $i = 0;

my @arguments;
while (@ARGV) {
    $arguments[$i++] = shift @ARGV;
}

my %keys = make_arg_hash (@arguments);

my @music;

my @coloms;
if (defined $keys{colums}) {
    for ($i = 0; defined $keys{colums}[$i]; $i++) {
        $coloms[$i] = $keys{colums}[$i];
    }
}
else { @coloms = ("band","year","album","treck","form"); }

$i = 0;
while (<>) {
    if (/\.\/.+\/\d{4} - .+\/.+\.[\w]+\s?/) {
        $music[$i++] = add_treck($_)
    }
}

if (defined $keys{band}) {
    @music = reduce_mus($keys{band},"band",@music);
}
#p @music;
table_out(@coloms,@music);
1;