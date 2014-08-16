use strict; use warnings;
package JSONY;
our $VERSION = '0.1.9';

use Pegex::Parser;
use JSONY::Grammar;
use JSONY::Receiver;

# XXX Old API has been removed, but warning for now.
{
    use base 'Exporter';
    our @EXPORT = qw(decode_jsony);

    sub decode_jsony {
        require Carp;
        Carp::croak("The decode_jsony() API has been replaced by JSONY->new->load()");
    }
}

sub new {
    bless {}, $_[0];
}

sub load {
    Pegex::Parser->new(
        grammar => JSONY::Grammar->new,
        receiver => JSONY::Receiver->new,
    )->parse($_[1]);
}

1;
