use lib 't';
use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/decode.tml',
    bridge => 'TestMLBridge',
)->run;
