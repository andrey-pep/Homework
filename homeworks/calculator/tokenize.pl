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
	$expr =~ tr/ //sd;					#убираем пробелы
	$expr =~ s/[a-df-zA-DF-Z]*//;		#если встретились лишние буквы, то выкидываем
	if ($expr =~ /\D[e]/ || $expr =~ /\d[\.]\d[\.]/ || !($expr =~ /[-+\^\/\*]/))		#если e идёт после не-цифры или более 1 точки в цифре или нет знаков операций
	{
        die "Problems with input\n";		# то закрываем всё
    }
	my $enough_num = 0;		#счётчик количества цифр, если их не будет, то закроем программу с ошибкой
	my @res = split m{((?<!e)[-+]|[*()/^]|\s+)}, $expr;		#делим входную строку на токены, которые потом ещё обработаем
while ($i <= $#res) 
{
	given($res[$i])
	{
		when ($res[$i] =~ /\d/)			#запись чисел в массив
		{
			$res[$i] = 0+$res[$i];
			$res[$i] = "$res[$i]";
			$enough_num += 1;		#это для счётчика чисел
		}
		when ([''])
		{
			splice (@res,$i,1);			#удаление пустых элементов массива
		}	
	}
    $i++;
    next;
}
if ($enough_num < 1) {die "Problems with input: no numbers\n";};		#выход, если нет чисел
$i=0;

while ($i <= $#res) 		#вторая проверка унарных символов
{
	my $next_ch = $res[$i+1];
	given($res[$i])
	{
		when(['-', '+', '^'])
		{
			if ($next_ch eq '*' || $next_ch eq '/')
			{
                die "Used binary operator after unary\n";		#бинарные не идут после унарных
            }
			if ($res[$i] eq '+' || $res[$i] eq '-')
			{
				if (($res[$i-1] =~ /[\D]/ || $i-1<0) && !($res[$i-1] =~ /[\d][\.][\d]/) ) 	#если унарные + или - , то приписываем U
					{
							$res[$i] = "U".$res[$i];
					}
			}
		}
	}
	$i++;
}
	$i = 0;			#обнуление счётчика для дальнейших проходов через функцию
	return \@res;
	1;
}
1;
