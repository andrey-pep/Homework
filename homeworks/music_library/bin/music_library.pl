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

our $VERSION = '1.00';

my @music;
my $i = 0;
my @coloms = ("band","year","album","treck","form");

while (<>) {
    if (/\.\/.+\/\d{4} - .+\/.+\.[\w]+\s?/) {
        $music[$i++] = add_treck($_)
    }
}

for my $item (@ARGV) {
    given ($item) {
        when("--band") {say "lol";}
    }
}
my @data = table_out(@coloms,@music);
#p @music;
#p @data;
#say $music[19]{"band"};
1;