use Test::More tests => 1;

use JSONY;

open JSONY, 'Changes' or die "Can't open 'Changes' for input";

my $jsony = do { local $/; <JSONY> };

decode_jsony($jsony);

pass 'Changes file is valid JSONY';
