use TestML -run,
    -require_or_skip => 'JSON',
    -require_or_skip => 'YAML';

use DJSON;
use JSON;
use YAML;
# $Pegex::Parser::Debug = 1;

sub djson_decode {
    decode_djson $_[0]->value;
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

# Make sure the djson parses to what we expect:
*djson.djson_decode.yaml == *json.json_decode.yaml;

=== Top Level Mapping
--- djson
foo: bar
baz: 42
--- json: {"foo": "bar", "baz": 42}

=== Top Level Sequence
--- djson
- foo bar
- foo bar
--- json: [["foo", "bar"],["foo", "bar"]]

