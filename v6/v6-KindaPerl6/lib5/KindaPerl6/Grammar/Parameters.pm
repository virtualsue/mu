# Do not edit this file - Generated by MiniPerl6
use v5;
use strict;
use MiniPerl6::Perl5::Runtime;
use MiniPerl6::Perl5::Match;
package KindaPerl6::Grammar; sub new { shift; bless { @_ }, "KindaPerl6::Grammar" } sub declare_parameters { my $List__ = \@_; my $env; my $block; my $sig; do {  $env = $List__->[0];  $block = $List__->[1];  $sig = $List__->[2]; [$env, $block, $sig] }; my  $vars = [Var->new( 'sigil' => '@','twigil' => '','name' => '_', ), $sig->invocant(), @{$sig->positional()}]; my  $decl; do { for my $var ( @{$vars} ) { do { if (Main::isa($var, 'Var')) { push(@{$decl}, Decl->new( 'decl' => 'my','var' => $var,'type' => '', )) } else {  } } } }; $env->add_lexicals($decl) }
;
1;
