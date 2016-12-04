package Local::JSONParser;
use JSON::XS;
use strict;

use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );
use Encode qw(decode);
use 5.010;
my $in_scope = 0;

sub parse_json {
	my $source = \$_[0];
	#return JSON::XS->new->utf8->decode($source);
	for ($$source) {
		if (/\G\s*"([^"\\]*)/gc) {
			my $str = decode ("utf8", $1);
			while(!(/\G"/gc)) {
				if (/\G\\([nt])/gc)
                {
                    if ($1 eq 'n')
                    {
                       $str = $str."\n";
                    }
                    else
                    {
                       $str = $str."\t";
                    }
                }
                elsif(/\G\\"/gc)
                {
                    $str = $str.'"';
                }
                elsif(/\G\\u(\w{4})/gc)
                {
                    my $tmp = chr(hex $1);
                    $str = $str.$tmp;
                }
                elsif(/\G([^"\\]*)\s*/gc)
                {
					$str = $str.decode("utf8", $1);
                }
				elsif(/\G(\\\\)/gc) {
					$str = $str.'\\';
				}
				else { die "There's some problems with JSON1"; }
			}
			return $str;
		}
		elsif (/\G\s*(-?\d+[\.eE]?\d*[-+]*\d*)/gc) {
			die "There's some problems with JSON2" if $in_scope == 0 or return $1;
		}
		elsif(/\G\s*[\'\"]?\[/gc) {
			$in_scope += 1;
			my $i = 0;
			my @subarr;
			while (!(/\G\s*\][\'\"]?/gc)) {
				$subarr[$i++] = parse_json($$source);
				/\G\s*,/gc;
			}
			$in_scope -= 1;
			return \@subarr;
        }
		elsif (/\G\s*\{/gc) {
			$in_scope += 1;
            my %subhesh;
            while(!(/\G\s*\}/gc)) {
                if (/\G\s*(\".*?\")\s*:/gc) {
                    my $key = $1;
					$key = parse_json($key);
                    $subhesh{$key} = parse_json($$source);
                    /\G\s*,/gc;
                }
                else { die "There's some problems with JSON3 $in_scope"; }
            }
			$in_scope -= 1;
            return \%subhesh;
        }
		else
			{ $in_scope = 0; die "There's some problems with JSON4 $in_scope"; }
	}
}
1;
