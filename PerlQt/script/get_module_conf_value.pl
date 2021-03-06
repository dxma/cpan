#! /usr/bin/perl -w
# Author: Dongxu Ma

use warnings;
use strict;
#use English qw( -no_match_vars );
use Carp;
use File::Spec ();
use Config;
use Getopt::Long qw/GetOptions/;

use YAML::Syck qw/Load Dump/;

my %opt;

=head1 DESCRIPTION

=cut

sub usage {
    print << "EOU";
usage        : $0 [mod_conf] [field_name]
mod_conf     : -conf <module.conf>
field_name   : -f <field_name>
EOU
    exit 1;
}

sub load_yaml {
    my $path = shift;
    local ( *YAML, );
    open YAML, "<", $path or croak "cannot open file to read: $!";
    my $cont = do { local $/; <YAML> };
    close YAML;
    return Load($cont);
}

sub main {
    GetOptions(
        \%opt,
        'conf=s',
        'f=s',
        'h|help',
    );
    usage() if $opt{h};
    #usage() if !@ARGV;
    croak "module.conf not found: $opt{conf}" if !-f $opt{conf};
    
    my $mod_conf= load_yaml($opt{conf});
    croak "no such field: $opt{f}" if !exists $mod_conf->{$opt{f}};
    print $mod_conf->{$opt{f}}, "\n";
    exit 0;
}

&main;

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 - 2011 by Dongxu Ma <dongxu@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

See L<http://dev.perl.org/licenses/artistic.html>

=cut
