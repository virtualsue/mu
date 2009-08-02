use v6;
use Test;

plan 14;

# L<S06/Closure parameters>

{
    my sub testit (&testcode) {testcode()}

    ok(testit({return 1}), 'code executes as testsub({...})');

    my $code = {return 1};
    ok(testit($code), 'code executes as testsub($closure)');

    my sub returntrue {return 1}
    ok(testit(&returntrue), 'code executes as testsub(&subroutine)');
}

# with a signature for the closure
#?rakudo skip 'type syntax parse failure'
{
    my sub testit (&testcode:(Int)) {testcode(12)}
    my sub testint(Int $foo) {return 1}
    my sub teststr(Str $foo) {return 'foo'}

    ok(testit(&testint), 'code runs with proper signature (1)');
    eval_dies_ok('testit(&teststr)', 'code dies with invalid signature (1)');
}

#?rakudo skip 'type syntax parse failure'
{
    my sub testit (&testcode:(Int --> Bool)) {testcode(3)}
    my Bool sub testintbool(Int $foo) {return Bool::True}
    my Bool sub teststrbool(Str $foo) {return Bool::False}
    my Int  sub testintint (Int $foo) {return 1}
    my Int  sub teststrint (Str $foo) {return 0}

    ok(testit(&testintbool), 'code runs with proper signature (2)');
    eval_dies_ok('testit(&testintint)',  'code dies with invalid signature (2)');
    eval_dies_ok('testit(&teststrbool)', 'code dies with invalid signature (3)');
    eval_dies_ok('testit(&teststrint)',  'code dies with invalid signature (4)');
}

#?rakudo skip 'type syntax parse failure'
{
    multi sub t1 (&code:(Int)) { 'Int' };
    multi sub t1 (&code:(Str)) { 'Str' };
    multi sub t1 (&code:(Str --> Bool)) { 'Str --> Bool' };
    multi sub t1 (&code:(Any, Any)) { 'Two' };

    is t1(-> $a, $b { }), 'Two',
       'Multi dispatch based on closure parameter syntax (1)'
    is t1(-> Int $a { }), 'Int',
       'Multi dispatch based on closure parameter syntax (2)'
    is t1(-> Str $a { }), 'Str',
       'Multi dispatch based on closure parameter syntax (3)'

    sub takes-str-returns-bool(Str $x --> Bool) { True }
    is t1(&takes-str-returns-bool), 'Str --> Bool',
       'Multi dispatch based on closure parameter syntax (4)'

    dies_ok { t1( -> { 3 }) }, 
       'Multi dispatch based on closure parameter syntax (5)'
}

# vim: ft=perl6
