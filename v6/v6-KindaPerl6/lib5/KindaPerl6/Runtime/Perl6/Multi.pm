{

    package Multi;

    # Do not edit this file - Perl 5 generated by KindaPerl6
    use v5;
    use strict;
    no strict 'vars';
    use KindaPerl6::Runtime::Perl5::Runtime;
    my $_MODIFIED;
    BEGIN { $_MODIFIED = {} }

    BEGIN {
        $_ =
          ::DISPATCH( $::Scalar, "new",
            { modified => $_MODIFIED, name => "$_" } );
    }
    do {
        if (
            ::DISPATCH(
                ::DISPATCH(
                    ::DISPATCH( $GLOBAL::Code_VAR_defined, 'APPLY', $::Multi ),
                    "true"
                ),
                "p5landish"
            )
          )
        {
        }
        else {
            do {
                ::MODIFIED($::Multi);
                $::Multi = ::DISPATCH(
                    ::DISPATCH(
                        $::Class, 'new',
                        ::DISPATCH( $::Str, 'new', 'Multi' )
                    ),
                    'PROTOTYPE',
                );
              }
        }
    };
    ::DISPATCH(
        ::DISPATCH( $::Multi, 'HOW', ),
        'add_parent',
        ::DISPATCH( $::Str, 'new', 'Code' )
    );
    ::DISPATCH(
        ::DISPATCH( $::Multi, 'HOW', ),
        'add_attribute',
        ::DISPATCH( $::Str, 'new', 'long_names' )
    );
    ::DISPATCH(
        ::DISPATCH( $::Multi, 'HOW', ),
        'add_method',
        ::DISPATCH( $::Str, 'new', 'select' ),
        ::DISPATCH(
            $::Method,
            'new',
            sub {
                my $List_candidates =
                  ::DISPATCH( $::Array, 'new',
                    { modified => $_MODIFIED, name => '$List_candidates' } );
                my $sub;
                $sub =
                  ::DISPATCH( $::Scalar, 'new',
                    { modified => $_MODIFIED, name => '$sub' } )
                  unless defined $sub;

                BEGIN {
                    $sub =
                      ::DISPATCH( $::Scalar, 'new',
                        { modified => $_MODIFIED, name => '$sub' } );
                }
                my $List__ =
                  ::DISPATCH( $::Array, 'new',
                    { modified => $_MODIFIED, name => '$List__' } );
                my $self;
                $self =
                  ::DISPATCH( $::Scalar, 'new',
                    { modified => $_MODIFIED, name => '$self' } )
                  unless defined $self;

                BEGIN {
                    $self =
                      ::DISPATCH( $::Scalar, 'new',
                        { modified => $_MODIFIED, name => '$self' } );
                }
                $self = shift;
                my $CAPTURE;
                $CAPTURE =
                  ::DISPATCH( $::Scalar, 'new',
                    { modified => $_MODIFIED, name => '$CAPTURE' } )
                  unless defined $CAPTURE;

                BEGIN {
                    $CAPTURE =
                      ::DISPATCH( $::Scalar, 'new',
                        { modified => $_MODIFIED, name => '$CAPTURE' } );
                }
                ::DISPATCH_VAR( $CAPTURE, "STORE", ::CAPTURIZE( \@_ ) );
                do {
                    ::MODIFIED($List__);
                    $List__ = ::DISPATCH( $CAPTURE, 'array', );
                };
                $List_candidates;
                $sub;
                do {
                    if (
                        ::DISPATCH(
                            ::DISPATCH(
                                ::DISPATCH(
                                    ::DISPATCH(
                                        $List__, 'INDEX',
                                        ::DISPATCH( $::Int, 'new', 0 )
                                    ),
                                    'isa',
                                    ::DISPATCH( $::Str, 'new', 'Capture' )
                                ),
                                "true"
                            ),
                            "p5landish"
                        )
                      )
                    {
                    }
                    else {
                        ::DISPATCH(
                            $GLOBAL::Code_die,
                            'APPLY',
                            ::DISPATCH(
                                $::Str,
                                'new',
'the parameter to Multi.select must be a Capture'
                            )
                        );
                    }
                };
                do {
                    for my $sub (
                        @{ ::DISPATCH(
                                $GLOBAL::Code_prefix_58__60__64__62_,
                                'APPLY',
                                ::DISPATCH(
                                    $GLOBAL::Code_prefix_58__60__64__62_,
                                    'APPLY',
                                    ::DISPATCH( $self, 'long_names', )
                                )
                              )->{_value}{_array}
                        }
                      )
                    {
                        do {
                            if (
                                ::DISPATCH(
                                    ::DISPATCH(
                                        ::DISPATCH(
                                            $GLOBAL::Code_infix_58__60__61__61__62_,
                                            'APPLY',
                                            ::DISPATCH(
                                                ::DISPATCH(
                                                    $sub, 'signature',
                                                ),
                                                'arity',
                                            ),
                                            ::DISPATCH(
                                                ::DISPATCH(
                                                    $List__, 'INDEX',
                                                    ::DISPATCH(
                                                        $::Int, 'new', 0
                                                    )
                                                ),
                                                'arity',
                                            )
                                        ),
                                        "true"
                                    ),
                                    "p5landish"
                                )
                              )
                            {
                                ::DISPATCH( $List_candidates, 'push', $sub );
                            }
                          }
                    }
                };
                do {
                    if (
                        ::DISPATCH(
                            ::DISPATCH(
                                ::DISPATCH(
                                    $GLOBAL::Code_infix_58__60__61__61__62_,
                                    'APPLY',
                                    ::DISPATCH( $List_candidates, 'elems', ),
                                    ::DISPATCH( $::Int, 'new', 1 )
                                ),
                                "true"
                            ),
                            "p5landish"
                        )
                      )
                    {
                        return (
                            ::DISPATCH(
                                $List_candidates, 'INDEX',
                                ::DISPATCH( $::Int, 'new', 0 )
                            )
                        );
                    }
                };
                ::DISPATCH(
                    $GLOBAL::Code_die,
                    'APPLY',
                    ::DISPATCH(
                        $::Str, 'new', 'can\'t resolve Multi dispatch'
                    )
                );
            }
        )
      )

      ;
    1
}

