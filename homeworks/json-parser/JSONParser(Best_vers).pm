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
		if    (/\G[,\t\n]*?\G"([^\{\[\(\]\}\)]+?)":\s?(\{.+\})+[\,\t\n\s]+(?=\")/gc) {				#разобраться с положением ифов, до этого это стояло в конце
			$hash{$1} = parse_json($2);
        }
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+?)":\s?"([\w\\\s]*?)"[,\t\n\s]*/gc) {
			my $str = $2;
			my $key = $1;
			$str =~ s/\\u(.{4})/chr($1)/ge;
			$hash{$key} = $str;
		}
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+?)":\s?(-?\d+?[\.eE]?\d*[-+]*\d*)[,\t\n\s]*/gc) {
			$hash{$1} = 0+$2;
		}
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+)?":\s?\[(.+?)\][,\t\n\s]*/gcs) {
			my @t = split (/,[\s]?/,$2);
			my $i = 0;
			for my $item (@t) {
				if (/\D+/) {
				$t[$i++] =~ s/\"//gc;
				}
			}
			$hash{$1} = (\@t);
		}
	else { pos()++; };
	}
}
	return {%hash};
}
1;
