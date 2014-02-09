use lib 't', 'inc';
use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/fail.tml',
    bridge => 'TestMLBridge',
)->run;
