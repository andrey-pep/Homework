use strict;
use warnings;
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;
use Local::Source::Text;
use Local::Reducer::MaxDiff;
use 5.010;
use DDP;

my $sum_reducer = Local::Reducer::Sum->new(
    field => 'price',
    source => Local::Source::Array->new(array => [
        '{"price": 0}',
        '{"price": 1}',
        '{"price": 2}',
        '{"price": 3}',
    ]),
    row_class => 'Local::Row::JSON',
    initial_value => 0,
);


my $sum_result;



$sum_result = $sum_reducer->reduce_n(2);
print $sum_result."\n";
p $sum_reducer -> reduced;

$sum_result = $sum_reducer->reduce_all();

print $sum_result."\n";
print $sum_reducer -> reduced;

p $sum_reducer -> source;
