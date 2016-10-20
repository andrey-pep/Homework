=head1 DESCRIPTION
Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке
Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"
Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"
=cut

use 5.010;
use strict;
use warnings;
use diagnostics;

my $i = 0;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub tokenize
{
	chomp(my $expr = shift);
	$expr =~ tr/ //sd;
	$expr =~ s/[a-df-zA-DF-Z]*//;
	if ($expr =~ /\D[e]/ || $expr =~ /\d[\.]\d[\.]/)
	{
        die "Problems with input\n";
    }
	my $enough_num = 0;
	my @res = split m{((?<!e)[-+]|[*()/^]|\s+)}, $expr;
while ($i <= $#res) 
{
	given($res[$i])
	{
		when ($res[$i] =~ /\d/)
		{
			$res[$i] = 0+$res[$i];
			$res[$i] = "$res[$i]";
			$enough_num += 1;
		}
		when ([''])
		{
			splice (@res,$i,1);
		}	
	}
    $i++;
    next;
}
if ($enough_num < 1) {die "Problems with input: no numbers\n";};
$i=0;

while ($i <= $#res) 
{
	my $next_ch = $res[$i+1];
	given($res[$i])
	{
		when(['-', '+', '^'])
		{
			if ($next_ch eq '*' || $next_ch eq '/')
			{
                die "Used binary operator after unary\n";
            }
			if ($res[$i] eq '+' || $res[$i] eq '-')
			{
				if (($res[$i-1] =~ /[\D]/ || $i-1<0) && !($res[$i-1] =~ /[\d][\.][\d]/) ) 
					{
							$res[$i] = "U".$res[$i];
					}
			}
		}
	}
	$i++;
}
	$i = 0;
	return \@res;
	1;
}
1;
