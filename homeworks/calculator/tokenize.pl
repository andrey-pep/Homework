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
	my @res = split m{((?<!e)[-+]|[*()/^]|\s+)}, $expr;

while ($i <= $#res) 
{
	given($res[$i])
	{
		when ($res[$i] =~ /\d/)
		{
			$res[$i] = 0+$res[$i];
			$res[$i] = "$res[$i]";
		}
		when ([''])
		{
			splice (@res,$i);
		}	
	}
    $i++;
    next;
}
$i=0;

while ($i <= $#res) 
{
	given($res[$i])
	{
		when(['-', '+', '^'])
		{
			if ($res[$i+1] eq '*' || $res[$i+1] eq '/')
			{
                die "Used binary operator after unary\n";
            }
            if ($res[$i-1] eq '(' || $res[$i-1] eq '*' || $res[$i-1] eq '/' || $res[$i-1] eq '^' || ($i-1)<0) 
				{
	                	$res[$i] = "U".$res[$i];
				}
		}
	}
	$i++;
}
	return \@res;
	1;
}
1;