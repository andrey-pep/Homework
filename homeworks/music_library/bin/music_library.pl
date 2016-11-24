#!/usr/bin/env perl
use JSON::XS;
use strict;
use warnings;
use feature 'say';
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::Parse;
use Local::MusicLibrary;
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
    @coloms = $keys{colums};
}
else { @coloms = ("band","year","album","treck","form"); }

p @coloms;

$i = 0;
while (<>) {
    if (/\.\/.+\/\d{4} - .+\/.+\.[\w]+\s?/) {
        $music[$i++] = add_treck($_)
    }
}


for ($i = 0; $i < @arguments; $i++) {
    given ($arguments[$i]) {
        when("--colums") {  }
    }
}

table_out(@coloms,@music);
1;