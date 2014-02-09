use lib 't', 'inc';
use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/load.tml',
    bridge => 'TestMLBridge',
)->run;
