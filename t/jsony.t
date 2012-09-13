use TestML -run,
    -require_or_skip => 'JSON',
    -require_or_skip => 'YAML';

use JSONY;
use JSON;
use YAML;
# $Pegex::Parser::Debug = 1;

sub jsony_decode {
    decode_jsony $_[0]->value;
}

sub json_decode {
    decode_json $_[0]->value;
}

sub yaml {
    my $yaml = YAML::Dump $_[0]->value;
    $yaml =~
        s{!!perl/scalar:JSON::XS::Boolean}
        {!!perl/scalar:boolean}g;
    return $yaml;
}

__DATA__
%TestML 1.0

# Make sure the JSONY parses to what we expect:
*jsony.jsony_decode.yaml == *json.json_decode.yaml;

=== Top Level Mapping
--- jsony
foo: bar
baz: 42
--- json: {"foo": "bar", "baz": 42}

=== Top Level Sequence
--- jsony
- foo bar
- foo bar
--- json: [["foo", "bar"],["foo", "bar"]]

