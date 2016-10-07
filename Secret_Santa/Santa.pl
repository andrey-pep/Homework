#!/usr/bin/env perl

use strict;
#use warnings;
use Data::Dumper;

my @santa;
my $i=0;
my $j;
my @people;
my %take;
my %in_the_end;
my $input;
my $whom;
my $workspace;

while ($_ = <>)
{
        chomp($_);
        $_=~ m/(.+)\s+(.*)$/;
        if(split (/ /, $_) > 1)
        {$santa[$i] = [$1 , $2];}
        else {$santa[$i]= $_;};
        $i++;
}

for($j=0; $j<$i;$j++)
{
       if(ref($santa[$j]))
       {
                for(my $t=0; $t<2; $t++)
                {
                        $workspace = $santa[$j][$t];
                        while (!($in_the_end{$workspace}))
                        {
                                $whom = int rand($i);
                                if ($ARGV[1] ne "spouse") {next if($j == $whom);}
                                if ($ARGV[2] ne "to_each") {next if (exists $in_the_end{$people[$whom]});}
                                if (ref($santa[$whom])) {$input = $santa[$whom][rand(2)-1];}
                                else {$input = $santa[$whom];};
                                next if($input eq $workspace);
                                next if(exists $take{$input});
                                last;
                        }
                        $in_the_end{$workspace} = $input;
                        $take{$input} = $input;
                }
        print Dumper(\%in_the_end);
        }
       else
       {
                $workspace = $santa[$j];
                        while (!(exists $in_the_end{$workspace}))
                        {
                                $whom = int rand($i);
                                if ($ARGV[1] ne "spouse") {next if($j == $whom);}
                                if ($ARGV[2] ne "to_each") {next if (exists $in_the_end{$people[$whom]});}
                                if (ref($santa[$whom])) {$input = $santa[$whom][rand(2)-1];}
                                else {$input = $santa[$whom];};
                                next if($input eq $workspace);
                                next if(exists $take{$input});
                                last;
                        }
                $in_the_end{$workspace} = $input;
                $take{$input} = $input;  
       }  
}
print Dumper(\%in_the_end);
