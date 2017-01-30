use strict;
use warnings;
use 5.010;
use Local::TCP::Calc;
use DDP;

my $str1 = "lol";
my $str2 = "lol";
#my $num = -sin(9**9**9);

my $str = "echo '(3+4' | bc";
my $num = `$str`;
print "\n";

my $a = sol("3+5");
print "lol $a\n";

my $f = Local::TCP::Calc->pack_message("Source");
p $f;
close $f;
my $string = Local::TCP::Calc->unpack_message("Source.gz");
p $string;

sub sol {
my $a = shift;
my $str = "echo '$a' | bc";
my $res = `$str`;
return $res;
}
