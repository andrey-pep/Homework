use strict;
use warnings;

use Test::More tests => 4;

use Local::Reducer::MaxDiff;
use Local::Source::Text;
use Local::Row::Simple;
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;

my $diff_reducer = Local::Reducer::MaxDiff->new(
    top => 'received',
    bottom => 'sended',
    source => Local::Source::FileHandler->new(fh =>"Source.txt"),
    row_class => 'Local::Row::Simple',
    initial_value => 0,
);

my $diff_result;

$diff_result = $diff_reducer->reduce_n(1);

$diff_result = $diff_reducer->reduce_all();
