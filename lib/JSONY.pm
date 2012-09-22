use strict;
use warnings;

package JSONY;
our $VERSION = '0.0.5';

use Pegex::Parser;
use JSONY::Grammar;
use JSONY::Receiver;

use base 'Exporter';
our @EXPORT = qw(decode_jsony);

sub decode_jsony {
    Pegex::Parser->new(
        grammar => JSONY::Grammar->new,
        receiver => JSONY::Receiver->new,
    )->parse($_[0]);
}

1;

=encoding utf8

=head1 NAME

JSONY - Relaxed JSON with a little bit of YAML

=head1 SYNOPSIS

    use JSONY;

    my $data = decode_jsony $jsony_string;

=head1 DESCRIPTION

JSONY is a data language that is simlar to JSON, just more chill. All valid
JSON is also valid JSONY (and represents the same thing when decoded), but
JSONY lets you omit a lot of the syntax that makes JSON a pain to write.

=head1 API

JSONY exports one function: C<decode_jsony>. You pass it a JSONY string and it
returns the decoded Perl data object.

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

Top level hashes can be ':' separated pairs or use curlies. Sub hashes require
curlies.

    foo: { bar baz }
    num: -1.2e3

    { "foo": { "bar": "baz" }, "num": -1.2e3 }

Top level arrays can use C<'- '> at the start of lines. Those arrays go the
end of line. Lines can be continued using a trailing comma. Sub arrays require
square brackets.

    - array of 4 scalars
    - array with [ sub
      array { of
      things }]
    - array of 7 things on,
      two lines

    [
      [ "array", "of", 4, "scalars" ],
      [ "array", "with", [ "sub", "array" { "of", "things" } ] ],
      [ "array", "of", 7, "things", on, "two", "lines" ]
    ]

More soon...

NOTE: You may want to look at the tests (especially C<t/decode.t>) to see the
full abilities of JSONY.

=head1 STATUS

B<BEWARE!!!>

JSONY is mst's idea, and ingy's Pegex based implementation. The language is
just a baby, and will change a lot, or may go away entirely.

Development people are currently working on this in C<#jsony> in
irc.freenode.net. Please drop by.

http://jsony.org coming soon.

=head1 AUTHORS

Ingy döt Net (ingy) <ingy@cpan.org>

Matt S. Trout (mst) <mst@shadowcat.co.uk>

=head1 COPYRIGHT

Copyright (c) 2012 Ingy döt Net

=head1 LICENSE

This library is free software and may be distributed under the same terms as
perl itself.
