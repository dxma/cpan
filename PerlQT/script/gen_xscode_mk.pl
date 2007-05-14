#! /usr/bin/perl -w

use strict;
#use English qw( -no_match_vars );
use Fcntl qw(O_WRONLY O_TRUNC O_CREAT);
use File::Spec ();
use YAML ();

=head1 DESCRIPTION

Create xscode.mk

B<NOTE>: Invoked after group of formatted qtedi productions completed.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Dongxu Ma <dongxu@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

See L<http://dev.perl.org/licenses/artistic.html>

=cut

sub usage {
    print STDERR << "EOU";
usage: $0 <in_xscode_dir> <out_xscode_dir> [<output_file>]
EOU
    exit 1;
}

sub main {
    usage if @ARGV < 2;
    
    my ( $in_xscode_dir, $out_xscode_dir, $out, ) = @ARGV;
    die "directory $in_xscode_dir not found!" unless 
      -d $in_xscode_dir; 
    
    my $xscode_dot_mk = '';
    my $excl_std_dot_meta = File::Spec::->catfile(
        $in_xscode_dir, 'std.meta');
    my @typemap_deps = ();
    
    foreach my $m (glob(File::Spec::->catfile(
        $in_xscode_dir, '*.meta'))) {
        my $meta = (File::Spec::->splitdir($m))[-1];
        ( my $classname = $meta ) =~ s/\.meta$//io;
        # no need to include classname.function
        # which has member function implementations
        my @deps = grep { not m/\.function$/io } 
          glob(File::Spec::->catfile(
              $in_xscode_dir, "$classname.*"));
        # no need to include classname.meta
        push @typemap_deps, grep { not m/\.meta$/io } @deps;
        # skip namespace std
        unless ($m eq $excl_std_dot_meta) {
            # deps for module.xs
            $xscode_dot_mk .= File::Spec::->catfile(
                $out_xscode_dir, "xs", "$classname.xs"). 
                  ": ". join(" ", @deps). "\n";
            # rule for module.xs
            $xscode_dot_mk .= 
              "\t\$(_Q)[[ -d \$(dir \$@) ]] || \$(CMD_MKDIR) \$(dir \$@)\n";
            $xscode_dot_mk .= "\t\$(_Q)\$(CMD_CREAT_XS) \$@ \$^\n\n";
        
            # get module name from .meta
            local ( *META );
            open META, "<", $m or die "cannot open file $m: $!";
            my $hcont = do { local $/; <META> };
            close META;
            my $entry = YAML::Load($hcont);
            my $module = exists $entry->{MODULE} ? $entry->{MODULE} : '';
            my @module = split /\:\:/, $module;
        
            # deps for module.pm
            $xscode_dot_mk .= File::Spec::->catfile(
                $out_xscode_dir, "pm", @module, 
                split /\_\_/, "$classname.pm"). 
                  ": $m ". File::Spec::->catfile(
                      $in_xscode_dir,
                      "$classname.function.public"). "\n"; 
            # rule for module.pm
            $xscode_dot_mk .= 
              "\t\$(_Q)[[ -d \$(dir \$@) ]] || \$(CMD_MKDIR) \$(dir \$@)\n";
            $xscode_dot_mk .= "\t\$(_Q)\$(CMD_CREAT_PM) \$@ \$^\n\n";
        }
    }
    # deps for typemap
    # GROUP_YAMLS added to make sure all files produced by 
    # gen_group are present
    $xscode_dot_mk .= "\$(TYPEMAP): ". 
      "\$(filter-out \%.meta \%.function,\$(GROUP_YAMLS)) ". 
        join(" ", @typemap_deps). "\n";
    $xscode_dot_mk .= 
      "\t\$(_Q)[[ -d \$(dir \$@) ]] || \$(CMD_MKDIR) \$(dir \$@)\n";
    $xscode_dot_mk .= "\t\$(_Q)\$(CMD_CREAT_TP) ". 
      "\$(GROUPLIST_DOT_MK) \$(IN_XSCODE_DIR) \$@\n\n";
    
    if (defined $out) {
        local ( *OUT, );
        sysopen OUT, $out, O_CREAT|O_WRONLY|O_TRUNC or die 
          "cannot open file to write: $!";
        print OUT $xscode_dot_mk;
        close OUT or die "cannot save to file: $!";
    }
    else {
        print STDOUT $xscode_dot_mk;
    }
    exit 0;
}

&main;