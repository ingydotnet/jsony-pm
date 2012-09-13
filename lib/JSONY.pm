use strict;
use warnings;

package JSONY;

use Pegex;
our $VERSION = '0.0.2';

use base 'Exporter';
our @EXPORT = qw(decode_jsony);

sub decode_jsony {
    pegex(
        jsony_grammar(),
        { receiver => 'JSONY::Receiver' },
    )->parse($_[0]);
}

use constant jsony_grammar => <<'...';
%grammar jsony
%version 0.0.1

jsony:
    seq | map | top_seq | top_map | list

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

top_seq: top_seq_entry+

top_seq_entry:
    /~ <DASH> <SPACE>+ /
    ( node* %% / <SPACE>+ / ( <comment> | <EOL> ) )

top_map:
    (string /~<COLON>~/ node ~)+

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

bare: /( [^ <excludes> ]* [^ <excludes> <COLON> ] )/

excludes: /
    <WS>
    <LCURLY><RCURLY>
    <LSQUARE><RSQUARE>
    <SINGLE><DOUBLE>
    <COMMA>
/

ws: /(: <WS> | <comment> )/

comment: / <HASH> <SPACE> <ANY>* <BREAK> /
...

###############################################################################
# The receiver class can reshape the data at any given rule match.
###############################################################################
package JSONY::Receiver;
use base 'Pegex::Receiver';
use boolean;

sub got_top_seq_entry { $_[1][0][0] }
sub got_top_map { $_[0]->got_map([$_[1]]) }
sub got_seq { $_[1]->[0] }
sub got_map { +{ map {($_->[0], $_->[1])} @{$_[1]->[0]} } }
sub got_string {"$_[1]"}
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

JSONY - Relaxed JSON with a little bit of YAML

=head1 SYNOPSIS

    use JSONY;

    my $data = decode_jsony $jsony_string;

=head1 DESCRIPTION

JSONY is a data language that is simlar to JSON, just more chill. All valid
JSON is also valid JSONY (and represents the same thing when deocded), but
JSONY lets you omit a lot of the syntax that makes JSON a pain to write.

=head1 JSONY SYNTAX

Here is some examples of JSONY followed by equivalent JSON:

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
full abilities of JSONY.

=head1 STATUS

B<BEWARE!!!>

JSONY is mst's idea, and ingy's Pegex based implementation. The language is
just a baby, and will change a lot, or may go away entirely.

Development people are currently working on this in C<#jsony> in
irc.freenode.net. Please drop by.

=head1 AUTHORS

Ingy döt Net (ingy) <ingy@cpan.org>

Matt S. Trout (mst) <mst@shadowcat.co.uk>

=head1 COPYRIGHT

Copyright (c) 2011 Ingy döt Net

=head1 LICENSE

This library is free software and may be distributed under the same terms as
perl itself.
