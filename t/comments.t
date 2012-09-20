use TestML -run,
    -bridge => 't::TestML_JSONY';
# $Pegex::Parser::Debug = 1;

__DATA__
%TestML 1.0

# TODO:
# Make sure the JSONY parses to what we expect:
# *jsony.jsony_decode.yaml == *json.json_decode.yaml;
1 == 1;

=== Trailing comment
--- jsony
- foo # foo
- bar
--- json: [ "foo", "bar", "baz" ]
