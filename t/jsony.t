use TestML -run,
    -bridge => 't::TestML_JSONY';
# $Pegex::Parser::Debug = 1;

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

