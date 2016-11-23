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

our $VERSION = '1.00';

my @music;
my $i = 0;

while (<>) {
    $music[$i++] = add_treck($_);
}

my @data = table_out("band","album",@music);

p @data;
say $music[19]{"band"};
1;