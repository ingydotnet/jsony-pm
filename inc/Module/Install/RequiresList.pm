#line 1
##
# name:      Module::Install::RequiresList
# abstract:  Report prerequisite modules and version numbers
# author:    Ingy döt Net <ingy@ingy.net>
# license:   perl
# copyright: 2011
# see:
# - Module::Install

use 5.008003;
package Module::Install::RequiresList;
use strict;
use base 'Module::Install::Base';

our $VERSION = '0.10';
our $AUTHOR_ONLY = 1;

my $requires = '
use IO::All 0.41;
use CPAN::Meta::YAML 0.003 ();
# use JSON 2.53 ();
# use Template::Toolkit::Simple 0.13 ();
1;
';

sub requires_list {
    my ($self) = @_;
    return $self unless $self->is_admin;
    eval "use IO::All; 1" or die $@;
    my $pkg = __PACKAGE__;
    io('Makefile')->append(<<"...");

requires-list ::
	\$(PERL) "-Ilib" "-M$pkg" -e "print '$pkg'->_requires_report()"

...

    return $self;
}

sub _requires_report {
    require CPAN::Meta::YAML;
    my ($self) = @_;
    my $data = $self->_requires_data;
    return CPAN::Meta::YAML::Dump($data);
#     my $template = $self->_fetch_template;
#     tt->render(\$template, $data);
}

sub _requires_data {
    my ($self) = @_;
    my $data = {
        requires => {},
#         recommends => {},
#         build => {},
#         author => {},
    };
    my $meta = CPAN::Meta::YAML::LoadFile('META.yml');
    my $requires = $data->{requires} = $meta->{requires};
    delete $requires->{perl};
    for my $module (sort keys %$requires) {
        my $list = $requires->{$module} = [ $requires->{$module} ];
        push @$list, eval "require $module; $module->VERSION" || 'unknown';
        push @$list, $self->_cpan_version($module);
    }
    return $data;
}

sub _cpan_version {
    my ($self, $module) = @_;
    my $str = `cpanm --info $module`;
    $str =~ /.*-(v?\d[\d\.]*)\./
        or die "Can't get version from '$str'";
    return $1;
}

1;

