use TestML -run;

use JSONY;
# $Pegex::Parser::Debug = 1;

sub jsony_decode {
    decode_jsony $_[0]->value;
}

__DATA__
%TestML 1.0

# Make sure these strings do not parse as JSONY.
*jsony.jsony_decode.Catch.OK;

=== Comma in bareword
--- jsony: { url: http://foo.com,2012 }

=== Unmatched [
--- jsony: foo[bar
