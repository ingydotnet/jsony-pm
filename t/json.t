use TestML -run,
    -require_or_skip => 'JSON',
    -require_or_skip => 'YAML';

use DJSON;
use JSON;
use YAML;

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

# Test various json streams, to make sure DJSON can parse it properly.
*json.djson_decode.yaml == *json.json_decode.yaml;

=== Various Numbers
--- json: [1,-2,3,4.5,67,0.8e-9]

=== Object with no space
--- json: {"a":"b","c":{"d":"e"},"f":["g","h"],"i":[{},[],[[]]]}
