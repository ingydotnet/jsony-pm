use Test::More tests => 1;

use DJSON;

open DJSON, 'Changes' or die "Can't open 'Changes' for input";

my $djson = do { local $/; <DJSON> };

decode_djson($djson);

pass 'Changes file is valid DJSON';
