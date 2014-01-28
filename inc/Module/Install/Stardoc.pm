#line 1
##
# name:      Module::Install::Stardoc
# abstract:  Stardoc Support for Module::Install
# author:    Ingy döt Net <ingy@cpan.org>
# copyright: 2011
# license:   perl

package Module::Install::Stardoc;
use 5.008003;
use strict;
use warnings;

use Module::Install::Base;
use vars qw'@ISA $VERSION';
BEGIN {
    @ISA = 'Module::Install::Base';
    $VERSION = '0.18';
}

use File::Find;

my @clean;

sub stardoc_make_pod {
    my $self = shift;
    return unless $self->is_admin;
    require Stardoc::Convert;
    eval "use IO::All; 1" or die $@;

    my @pms = @_;

    if (not @pms) {
        File::Find::find(sub {
            push @pms, $File::Find::name if /\.pm$/;
        }, 'lib');
    };
    for my $pm (@pms) {
        (my $pod = $pm) =~ s/\.pm$/.pod/ or die;
        my $doc = Stardoc::Convert->perl_file_to_pod($pm) or next;
        push @clean, $pod;
        my $old = -e $pod ? io($pod)->all : '';
        if ($doc ne $old) {
            print "Creating $pod from $pm\n";
            io($pod)->print($doc);
        }
    }
}

sub stardoc_clean_pod {
    my $self = shift;
    return unless $self->is_admin;
    $self->clean_files(join ' ', @clean);
}

1;

#line 75
