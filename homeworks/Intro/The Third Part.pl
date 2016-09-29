#!/usr/bin/perl
use strict;
use Data::Dumper;
use warnings;

my @massofmass=();
my $count=0;
my $filename = 'file.txt';
open(my $fh, '<', $filename)
        or die "Counld not open file '$filename' $!";
      
while (my $row = <$fh>) {
my @timemas=();
@timemas=split(/;|\n/, $row);
@massofmass[$count] = \@timemas;
#print @timemas, "  that\n";
$count++;
}
print Dumper(@massofmass);
close($fh)
  or die "Counld not close file '$filename' $!";
