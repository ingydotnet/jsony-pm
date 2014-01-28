#line 1
##
# name:      Pegex::Receiver
# abstract:  Pegex Receiver Base Class
# author:    Ingy döt Net <ingy@cpan.org>
# license:   perl
# copyright: 2011, 2012
# see:
# - Pegex::Tree
# - Pegex::Tree::Wrap
# - Pegex::Pegex::AST

package Pegex::Receiver;
use Pegex::Base;

has parser => (); # The parser object.

# Flatten a structure of nested arrays into a single array in place.
sub flatten {
    my ($self, $array, $times) = @_;
    $times //= -1;
    while ($times-- and grep {ref($_) eq 'ARRAY'} @$array) {
        @$array = map {
            (ref($_) eq 'ARRAY') ? @$_ : $_
        } @$array;
    }
    return $array;
}

1;

