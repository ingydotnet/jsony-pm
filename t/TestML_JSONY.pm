package t::TestML_JSONY;
use strict;

use JSONY;
use JSON;
use YAML;

sub jsony_decode {
    decode_jsony $_[0]->value;
}

sub json_decode {
    decode_json $_[0]->value;
}

sub yaml {
    my $yaml = YAML::Dump $_[0]->value;

    # Account for various JSONs
    $yaml =~
        s{!!perl/scalar:JSON::(?:XS::|PP::|backportPP::|)Boolean}
        {!!perl/scalar:boolean}g;

    # XXX Floating point discrepancy hack
    $yaml =~ s/\.000+1//g;

    return $yaml;
}

1;
