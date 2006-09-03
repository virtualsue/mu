package Pugs::Compiler::RegexPerl5;

# Version in Pugs::Compiler::Rule
# Documentation in the __END__
use 5.006;
use strict;
use warnings;

#use base 'Pugs::Compiler::Regex';

#use Pugs::Compiler::Regex;
#sub code { (+shift)->Pugs::Compiler::Regex::code( @_ ) }

# http://www.foo.be/docs/tpj/issues/vol2_3/tpj0203-0002.html
# is a good reference on the use of pos()

sub compile {
    my ( $class, $rule_source, $param ) = @_;
    $param = ref $param ? { %$param } : {}; 
    delete $param->{P5};
    delete $param->{Perl5};
    warn "Error in rule: unknown parameter '$_'" 
        for keys %$param;
    my $self = { source => $rule_source };
    $self->{perl5} = 
q(sub {
  no warnings 'uninitialized';
  my $s = $_[1];

  if ( defined $_[3]{p} ) {
    pos($s) = $_[3]{p};
    my $bool = \( $s =~ /\G) . $rule_source . q(/sx \) ? 1 : 0;
    #print "matching P5/$rule_source/ at $_[3]{p} in '$s', '$1', $bool\n";
    my @match;
    for ( 1 .. $#+ ) {
      push @match, Pugs::Runtime::Match->new({
        str => \\$s, from => \\(0+$-[$_]), to => \\(0+$+[$_]),
        bool => \\1, match => [], named => {}, capture => undef,
      });
    }
    return Pugs::Runtime::Match->new({
      str => \\$s, from => \\(0+$-[0]), to => \\(0+$+[0]),
      bool => \\$bool, match => \\@match, named => {}, capture => undef,
    });
  }

  my $bool = \( $s =~ /) . $rule_source . q(/sx \) ? 1 : 0;
  # print "matching P5/$rule_source/ at $_[3]{p} in '$s', '$1'\n";
  my @match;
  for ( 1 .. $#+ ) {
      push @match, Pugs::Runtime::Match->new({
        str => \\$s, from => \\(0+$-[$_]), to => \\(0+$+[$_]),
        bool => \\1, match => [], named => {}, capture => undef,
      });
  }
  return Pugs::Runtime::Match->new({
    str => \\$s, from => \\(0+$-[0]), to => \\(0+$+[0]),
    bool => \\$bool, match => \\@match, named => {}, capture => undef,
  });

};
);
    # print 'rule perl5: ', do{use Data::Dumper; Dumper($self->{perl5})};

    local $@;
    $self->{code} = eval 
        $self->{perl5};
    die "Error in evaluation: $@\nSource:\n$self->{perl5}\n" if $@;

    bless $self, 'Pugs::Compiler::Regex';
}

1;

__END__

=head1 NAME 

Pugs::Compiler::RegexPerl5 - Compiler for Perl 6 style "Perl5" regex

=head1 DESCRIPTION

This module provides an implementation for Perl 6 regexes that use the "Perl5" switch:

    :Perl5 /.*/

    :P5 /.*/

See L<Pugs::Compiler::Rule> for documentation.

=head1 AUTHORS

The Pugs Team E<lt>perl6-compiler@perl.orgE<gt>.

=head1 SEE ALSO

The Perl 6 Rules Spec: L<http://dev.perl.org/perl6/doc/design/syn/S05.html>

=head1 COPYRIGHT

Copyright 2006 by Flavio Soibelmann Glock and others.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
