use strict;
use warnings;

package DJSON;

use Pegex;
our $VERSION = '0.0.1';

use base 'Exporter';
our @EXPORT = qw(decode_djson);

sub decode_djson {
    pegex(
        djson_grammar(),
        { receiver => 'DJSON::Receiver' },
    )->parse($_[0]);
}

use constant djson_grammar => <<'...';
%grammar djson
%version 0.0.1

djson: map | seq | list

node: map | seq | scalar

map:
    ~LCURLY~
    pair*
    ~RCURLY~

pair: string /~<COLON>?~/ node /~<COMMA>?~/

seq:
    ~LSQUARE~
    node* %% /~<COMMA>?~/
    ~RSQUARE~

list: node* %% /~<COMMA>?~/

scalar: double | single | bare

string: scalar

double: /
    <DOUBLE>
    ([^ <DOUBLE> ]*)
    <DOUBLE>
/

single: /
    <SINGLE>
    ([^ <SINGLE> ]*)
    <SINGLE>
/

bare: /(
    [^
        <WS>
        <LCURLY><RCURLY>
        <LSQUARE><RSQUARE>
        <SINGLE><DOUBLE>
        <COMMA>
    ]+
)/

ws: /(: <WS> | <comment> )/

comment: / <HASH> <SPACE> <ANY>* <BREAK> /
...

###############################################################################
# The receiver class can reshape the data at any given rule match.
###############################################################################
package DJSON::Receiver;
use base 'Pegex::Receiver';
use boolean;

sub got_string {"$_[1]"}
sub got_map { +{ map {($_->[0], $_->[1])} @{$_[1]->[0]} } }
sub got_seq { $_[1]->[0] }
sub got_bare {
    $_ = pop;
    /true/ ? true :
    /false/ ? false :
    /null/ ? undef :
    /^(
        -?
        (?: 0 | [1-9] [0-9]* )
        (?: \. [0-9]* )?
        (?: [eE] [\-\+]? [0-9]+ )?
    )$/x ? ($_ + 0) :
    "$_"
}

=encoding utf8

=head1 NAME

DJSON - The Degenerate JSON Data Language

=head1 SYNOPSIS

    use DJSON;

    my $data = decode_djson $djson_string;

=head1 DESCRIPTION

DJSON is a data language that is simlar to JSON, just more chill. All valid
JSON is also valid DJSON (and represents the same thing when deocded), but
DJSON lets you omit a lot of the syntax that makes JSON a pain to write.

=head1 DJSON SYNTAX

Here is some examples of DJSON followed by equivalent JSON:

Words don't need quotes. A list of things is an array:

    foo bar baz

    [ "foo", "bar", "baz" ]

Strings with spaces can use single or double quotes:

    'foo bar'      # <= This is (a comment indicating) a string
    # More commenting
    "baz  boom "

    [ "foo bar ", "baz  boom " ]

Hashes still need curly braces:

    {
        foo { bar baz }
        num -1.2e3
    }

    { "foo": { "bar": "baz" }, "num": -1.2e3 }

More soon...

NOTE: You may want to look at the tests (especially C<t/decode.t>) to see the
full abilities of DJSON.

=head1 STATUS

B<BEWARE!!!>

DJSON is mst's idea, and ingy's Pegex based implementation. The language is
just a baby, and will change a lot, or may go away entirely.

Development people are currently working on this in C<#pegex> in
irc.freenode.net. Please drop by.

=head1 AUTHORS

Ingy döt Net (ingy) <ingy@cpan.org>

Matt S. Trout (mst) <mst@shadowcat.co.uk>

=head1 COPYRIGHT

Copyright (c) 2011 Ingy döt Net

=head1 LICENSE

This library is free software and may be distributed under the same terms as
perl itself.
