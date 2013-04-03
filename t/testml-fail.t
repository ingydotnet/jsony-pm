use lib 't';
use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/fail.tml',
    bridge => 'TestMLBridge',
)->run;
