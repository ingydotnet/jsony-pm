use File::Basename;
use lib dirname(__FILE__), 'inc';
use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/fail.tml',
    bridge => 'TestMLBridge',
)->run;
