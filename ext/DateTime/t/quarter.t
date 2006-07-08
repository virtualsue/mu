use v6-alpha;
use Test;
plan 32;

use Date;

for [ 2004,  1,  1, 1,  1 ],
    [ 2004,  3, 31, 1, 91 ],
    [ 2004,  4,  1, 2,  1 ],
    [ 2004,  6, 30, 2, 91 ],
    [ 2004,  7,  1, 3,  1 ],
    [ 2004,  9, 30, 3, 92 ],
    [ 2004, 10,  1, 4,  1 ],
    [ 2004, 12, 31, 4, 92 ],
    [ 2005,  1,  1, 1,  1 ],
    [ 2005,  3, 31, 1, 90 ],
    [ 2005,  4,  1, 2,  1 ],
    [ 2005,  6, 30, 2, 91 ],
    [ 2005,  7,  1, 3,  1 ],
    [ 2005,  9, 30, 3, 92 ],
    [ 2005, 10,  1, 4,  1 ],
    [ 2005, 12, 31, 4, 92 ] {
    my ( $y, $m, $d, $q, $doq ) = @$_;

    my $date = Date.new( year => $y, month => $m, day => $d );

    is( $date.quarter, $q, "quarter is $q" );
    is( $date.day_of_quarter, $doq, "day of quarter is $doq" );
}
