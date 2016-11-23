#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::Parse;
use DDP;

my @music;
my $i = 0;

while (<>) {
    $music[$i++] = add_treck($_);
}


p @music;
1