package DJSON;

use Pegex;
our $VERSION = '0.0.1';

use base 'Exporter';
our @EXPORT = qw(decode_djson);

sub djson_grammar;

sub decode_djson {
    pegex(
        djson_grammar,
        { receiver => 'DJSON::Receiver' },
    )->parse($_[0]);
}

use constant djson_grammar => <<'...';
%grammar djson
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

# The receiver class can reshape the data at any given rule match.
package DJSON::Receiver;
use base 'Pegex::Receiver';

# Receiving ('got_') methods can be defined for each rule, and get called
# after a match. But often the default shape of the data is fine, and a method
# need not be implemented for every rule.
sub got_rulename {
    my ($self, $data) = @_;
    # ... change data if needed
    return $data;
}

# Two special methods: 'initial' and 'final' can be defined and get called
# before and after a successful parse.

# sub initial {
#     my ($self) = @_;
#     # Do initialization tasks
# }

# sub final {
#     my ($self, $data) = @_;
#     # Perform last rites on $data
#     return $data;
# }
