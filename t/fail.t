use TestML -run;

use DJSON;
# $Pegex::Parser::Debug = 1;

sub djson_decode {
    decode_djson $_[0]->value;
}

__DATA__
%TestML 1.0

# Make sure these strings do not parse as DJSON.
*djson.djson_decode.Catch.OK;

=== Comma in bareword
--- djson: { url: http://foo.com,2012 }

=== Unmatched [
--- djson: foo[bar
