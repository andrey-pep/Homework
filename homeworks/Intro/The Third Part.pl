#!/usr/bin/perl
use strict;
use Data::Dumper;
use warnings;

my @massofmass=();
my $count=0;
      
while (<>) {
my @timemas=();
@timemas=split(/;|\n/, $_);
@massofmass[$count] = \@timemas;
$count++;
}
print Dumper(@massofmass);
