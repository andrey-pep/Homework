package Local::JSONParser;
use JSON::XS;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );
use DDP;
use feature 'say';
use utf8;

sub parse_json {
	my $source = shift;
my %hash;
#return JSON::XS->new->utf8->decode($source);
for ($source) {
	while (pos() < length()) {
				if    (/\G[\,\t\n\s]?"([^\{\[\(\]\}\)]+?)":\s?(\{.+?\})+[\,\t\n\s]*?(?=\")?/gc) {				#разобраться с положением ифов, до этого это стояло в конце
			my $str = $2;
			my $key = $1;
			say "$key     and     $str";
			$hash{$key} =  parse_json($str);
        }
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+?)":\s?"([\w\\\s]*?)"[,\t\n\s]*/gc) {
			my $str = $2;
			my $key = $1;
			$str =~ s/\\u(.{3,4})/my $num = hex($1); chr($num)/ge;
			$str =~ s/(\\n)/chr(10)/ge;
			$str =~ s/(\\t)/chr(9)/ge;
			$str =~ s/(\\")/chr(34)/ge;
			$hash{$key} = $str;
		}
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+?)":\s?(-?\d+?[\.eE]?\d*[-+]*\d*)[,\t\n\s]*/gc) {
			$hash{$1} = 0+$2;
		}
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+)?":\s?\[(.+?)\][,\t\n\s]*/gcs) {
			my @t = split (/(?<!\\"),[\s]*/g,$2);		#my @t = split (/(?<!\\[\"]),[\s]*/g,$2);   ой ли
			my $i = 0;
			for my $item (@t) {				#$item =~ s/\\u(.{3,4})/my $num = hex($1); chr($num)/ge;
				if (/\D+/) {				#$item =~ s/(\\n)/chr(10)/ge;
				$t[$i++] =~ s/\"//gc;			#$item =~ s/(\\t)/chr(9)/ge;
				}					#$item =~ s/(\\")/chr(34)/ge;
			}
			$hash{$1} = (\@t);
		}
	else { pos()++; };
	}
}
	return {%hash};
}
1;
