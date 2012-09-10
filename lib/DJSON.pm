package DJSON;
use Moo;

use Pegex;
use base 'Exporter';

our $VERSION = '0.0.1';
our @EXPORT = qw(decode_djson);

use constant djson_grammar => <<'...';
%grammar json
%version 0.0.1

djson: map | seq | list

node: map | seq | list | scalar

map:
    / ~ <LCURLY> ~ /
    pair* scalar?
    / ~ <RCURLY> ~ /

pair: string ~~ node

seq:
    / ~ <LSQUARE> ~ /
    node* % / ~ <COMMA>? ~ /
    / ~ <RSQUARE> ~ /

list:
    string* % / ~ <COMMA>? ~ /

scalar:
    number |
    boolean |
    null |
    string

# string and number are interpretations of http://www.json.org/
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

bare: /(<NS>+)/

number: /(
    <DASH>?
    (: 0 | [1-9] <DIGIT>* )
    (: <DOT> <DIGIT>* )?
    (: [eE] [<DASH><PLUS>]? <DIGIT>+ )?
)/

boolean: true | false

true: /true/

false: /false/

null: /null/
...

sub decode_djson {
    return pegex(
        djson_grammar,
        { receiver => 'DJSON::Receiver' },
    )->parse($_[0]);
}

package DJSON::Receiver;
use base 'Pegex::Receiver';

sub final {
    return $_[1];
}
