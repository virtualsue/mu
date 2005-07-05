=pod

Perl6's grammer written as a Perl6 rules.  A prerequisite for self hosting.

=cut

grammar Perl6;

# Top leval structures.

#rule code { ... } # A section of code.

#rule block { \{ <code> \} } # A block of code.

# Subs and sublikes

#rule lexicalsub :w { # From A06
#        <lexscope> <type>?
#        <submodifer>? <subintro> <subname> <psignature>?
#        <trait>*
#        <block>
#}

#rule lexicalsub  { # From A06
#        <lexscope> \s* <type>?
#        <submodifer>? \s* <subintro> \s* <subname> \s <psignature>?
#        <trait>*
#        <block>
#}
#rule packagesub :w { # From A06
#        <submodifer> <subintro> <subname> <psignature>?
#        <trait>*
#        <block>
#}

#rule anonsub { # Modiefied because pugs doesn't do :w
#        <subintro> \s* <psignature>? \s*
#        <trait>* \s*
#        <block>
#}

## Pointy subs
#
#rule pointysub :w { # From A06
#        -\> <signature> <block>
#}
#
# Variables 
# From A06

rule sigil { <[$@%&]> <[*.?^]>? }   # "What is that, swearing?"
rule variable { <sigil> <name> [ \( <siglet> \) ]? }

# Bare subs
# From A06

#rule baresub :w {
#        <block> { .find_placeholders() }
#}
#
## Identifiers
#
rule name_sec { <-[0..9:.]> <-[:]>* };
#
rule name {  <name_sec>
             | [\:\: <name_sec> ]+
             | <name_sec> [\:\: <name_sec> ]+};

## What is the diffrence between an ident, a name and a subname
## A06 doesn't tell me even though it uses them.  These are guesses
## untill we are enlightended.
#
rule subname { \*?<name> };
#
rule ident {<name>};
#
# Numbers

# Numbers base 10.

rule natural { <digit> [_* <digit> _*]* };

rule Int {[\+|\-]? <natural>};

rule decimal { <Int> [\. <natural>? ]?
              | [\+|\-]? \. <natural>
             };

rule Rat  { <decimal> [ [e|E] <Int>]? };

# Numbers base anything else.

rule binary { 0b <[01]>+ };

rule hex    { 0x <[0..9a..fA..F]>+};

rule oct    { 0o <[0..7]>+};

# A rule to match any perl style number.

rule Num { Int | Rat | binary | hex | oct  };

## These are defined in A06
#
## Siglets
#
#rule siglet :w {
#        [<paramlet> [<[,:]> <paramlet> ]* ]?
#}
#
#rule paramlet :w {
#        [ <type> <zone>? <varlet>? <trait>*     # require type
#        | <zone> <varlet>? <trait>*             # or zone
#        | <varlet> <trait>*                     # or varlet
#        | \[ <siglet> \]        # treat single array ref as an arg list
#        ]
#}
#
#rule varlet :w {
#        <sigil> [ \( <siglet \) ]?
#}
#
## Defaults
#
#rule defval :w { \= <item> }
#
## Placeholders
#
#rule placeholder { <sigil> \^ <ident> }
#
## Formal parameter syntax
#
#rule parameter :w {
#        [ <type>? <zone>? <variable> <trait>* <defval>?
#        | \[ <signature> \]     # treat single array ref as an arg list
#        ]
#}
#
#rule signature :w {
#        [<parameter> [<[,:]> <parameter> ]* ]?
#}
#
## The sub form
#
#rule subintro { sub | method | submethod | rule | macro }
#
#rule lexscope { my | our }
#
#rule submodifer { multi }
#
#rule psignature :w { \( <signature> \) }
#
#rule psiglet :w { \( <siglet> \) }
#
#rule scopedsubvar :w {
#        <lexscope> <type>? &<subname> <psiglet>? <trait>*
#}
#
#rule unscopedsubvar :w {
#        &<subname> <psiglet>? <trait>*
#}
#
#rule trait :w {
#          is <ident>[\( <traitparam> \)]?
#        | will <ident> <closure>
#        | of <type>
#        | returns <type>
#}
#

