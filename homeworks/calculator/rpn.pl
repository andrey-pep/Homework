=head1 DESCRIPTION
Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке
=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub op_priorit				#функция для расстановки приоритетов операций
{
	my $oper;
	($oper) = @_;
	if (!(defined $oper))               { return 0; };
	if ($oper eq "(" || $oper eq ")")   { return 0; };
	if ($oper eq "^")                   { return 3; };
	if ($oper eq "/" || $oper eq "*")   { return 2; };
	if ($oper eq "U-" || $oper eq "U+") { return 4; };
	if ($oper eq "+" || $oper eq "-")   { return 1; };
	1;
}

sub op_assotiation			#функция для расстановки ассоциативности операций
{
	my $op;
	($op) = @_;
	if (!(defined $op))                               		  { return 0; };
	if ($op eq "U+" || $op eq "U-" || $op eq "^") 			  { return 1; };
    if ($op eq "+" || $op eq "*" || $op eq "/" || $op eq "-") { return 0; };
	if ($op eq "(" || $op eq ")") 							  { return 2; };
	1;
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @stack;		#стэк операций
	my @rpn;
	my $i=0;
	my $scope_flag = 0;		#флаг количества скобок
	while ( defined (my $c=@$source[$i]))
	{
        if($c =~ /\d/) {push(@rpn,$c);}		#числа на выход
		else
		{
			if (op_assotiation($c) == 1)		#если правоассоциативные
			{
                if (op_priorit($c) < op_priorit($stack[0]))		#если приоритет ниже приоритета нижнего числа в стеке
				{
                    while (my $el = pop(@stack))		#переносим всё из стека на выход
					{
						if ($el eq "(") {last;}		#до скобки или конца стека
                        push(@rpn,$el);
                    }
				}
				push(@stack,$c);		#саму операцию в стек
            }
			if (op_assotiation($c) == 0)		#если левоассоциативная операция или первая (undef)
			{
                if (op_priorit($c) <= op_priorit($stack[$#stack]))	#если приоритет операции меньше или равен приоритету операции на вершине стека
				{
                    while (my $el = pop(@stack)) 	#переносим всё из стека на выход
					{
						if ($el eq "(") {last;} 	#до скобки или конца стека
                        push(@rpn,$el);
                    }
				}
				push(@stack,$c);
			}
			if (op_assotiation($c) == 2)		#если скобка
			{
                 if ($c eq "(")		#при открывающейся закидываем её в стек и увеличиваем переменную скобок
				{
					push(@stack,$c);
					$scope_flag += 1;
				}
				else		#когда закрывающаяся
				{
					if ($scope_flag == 0)
						{die "Problems with scopes\n";}		#если не было открывающихся, то выводим ошибку и выход из программы
					$scope_flag -= 1;						#уменьшаем значение в переменной скобок
					while ((my $el = pop(@stack)))		#переносим всё из стека на выход
					{
						if ($el eq "(") {last;}			#до скобки или конца стека
						else {push(@rpn,$el);}
					}
				}
            }
            
		}
		$i++;
	}
	while (my $el = pop(@stack))		#остаток стека операций на выход
	{
        push(@rpn,$el);
    }
	$i = 0;		#обнуление счётчика для дальнейших проходов через функцию
	return \@rpn;
	1;
}

1;
