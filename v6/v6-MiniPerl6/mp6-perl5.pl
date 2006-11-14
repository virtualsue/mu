package main;
use Config;
use lib split(/\Q$Config{path_sep}/, $ENV{PERL6LIB} || '');
use Scalar::Util;
use strict;
no strict 'refs';
no warnings ('void', 'uninitialized');
$::_V6_COMPILER_OS      = 'darwin';
$::_V6_COMPILER_NAME    = 'v6.pm';
$::_V6_COMPILER_VERSION = '0.015';
local $::_V6_MATCH_;

use MiniPerl6::Perl5::Runtime;

package Main;
sub new { bless { @_ }, "Main" }
use MiniPerl6::Grammar;
use MiniPerl6::Emitter;
use MiniPerl6::Grammar::Regex;
use MiniPerl6::Emitter::Token;

my $source = $::_V6_STDIN->slurp();
my $p = MiniPerl6::Grammar->parse(${$source});
#say( perl( ${$p} ) );
say( join( ";\n", (map { $_->emit() } @{ ${$p} } )));
say( "1;\n" );
