use lib 't';
use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/json.tml',
    bridge => 'TestMLBridge',
)->run;
