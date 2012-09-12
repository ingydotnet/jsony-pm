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

pair: string ~~ node~

seq:
    ~LSQUARE~
    node* %% /~<COMMA>?~/
    ~RSQUARE~

list:
    node* %% /~<COMMA>?~/

scalar:
    number |
    boolean |
    null |
    string

string: double | single | bare

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
    ]+
)/

number: /(
    <DASH>?
    (: 0 | [1-9] <DIGIT>* )
    (: <DOT> <DIGIT>* )?
    (: [eE] [<DASH><PLUS>]? <DIGIT>+ )?
    (= <WS> | <COMMA>)
)/

boolean: true | false

true: /true/

false: /false/

null: /null/
...

###############################################################################
# The receiver class can reshape the data at any given rule match.
###############################################################################
package DJSON::Receiver;
use base 'Pegex::Receiver';
use boolean;

sub got_map {
    my ($self, $data) = @_;
    $data = $data->[0];
    my $map = {};
    for my $pair (@$data) {
        $map->{$pair->[0]} = $pair->[1];
    }
    return $map;
}

sub got_seq {
    my ($self, $data) = @_;
    return $data->[0];
}

sub got_number { return $_[1] + 0 }
sub got_true { return true }
sub got_false { return false }
sub got_null { return undef }
