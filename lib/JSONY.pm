use strict; use warnings;
package JSONY;
our $VERSION = '0.1.13';

use Pegex::Parser;
use JSONY::Grammar;
use JSONY::Receiver;

sub new {
    bless {}, $_[0];
}

sub load {
    Pegex::Parser->new(
        grammar => JSONY::Grammar->new,
        receiver => JSONY::Receiver->new,
        # debug => 1,
    )->parse($_[1]);
}

1;
