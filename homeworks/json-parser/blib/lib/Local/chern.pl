#!/usr/bin/env perl

use strict;
use warnings;
use DDP;
use Data::Dumper;
my $i = 0;
my %JS = {};
my @keys = ();
while (my $string = <>) {
    my @t = ();
@t = $string =~ /(".+": \d)/g;
@keys = (@keys, @t);
print " enough\n";
}
p @keys;
my $string = "sample string sampl eshit";
my @a = $string =~ /sample/g; # list of caps
p @a;
#my @parts =split (/(?<=[\"\d\}\]\n]),(?=[\"\n\s])/, $source);
#my @parts =split (/(?<=[\"\d\}\]\n]),(?![\"\d] | ?=[\n])/, $source);

#my @parts =split (/(\[.*\],)|(\{.*\},)|(\(*\),)|(", "\w+)/, $source);

#my @parts =split (/(".*": \[.*\],)|(".*": \{.*\},)|(".*" :\(*\),)|(".*": "\w+")| (".*": -?\d+\.?\d*)/, $source);
my $abc = "aaabbc";
$abc =~ /aaab/s;
print $abc."\n";