#! /usr/bin/perl -w

use strict;
#use English qw( -no_match_vars );

use Fcntl qw(O_CREAT O_WRONLY);
use Parse::RecDescent;

=head1 DESCIPTION

Parse specified CPP header file. Get all required information for
marshalling interface.

B<NOTE>: currently focus on typedef and class declaration mainly.

=cut

# Global flags 
# unless undefined, report fatal errors
#$::RD_ERRORS = 1;
# unless undefined, also report non-fatal problems
#$::RD_WARN = 1;
# if defined, also suggestion remedies
$::RD_HINT = 1;
# if defined, also trace parsers' behaviour
#$::RD_TRACE = 1;
# if defined, generates "stubs" for undefined rules
#$::RD_AUTOSTUB = 1;
# if defined, appends specified action to productions
#$::RD_AUTOACTION = 1;

sub usage {
    print STDERR << "EOU";
usage: $0 <path_to_blah.h> [<path_to_result>]
EOU
    exit 1;
}

sub main {
    usage() unless @ARGV;
    
    my ( $in, $out ) = @ARGV;
    die "file not found: $!" unless -f $in;
    my $source;
    local ( *OUT );
    
    my $grammar = do { local $/; <DATA> };
    my $parser = Parse::RecDescent::->new($grammar);
    
    {
        local ( *IN );
        open IN, '<', $in or die "cannot open file: $!";
        local $/;
        $source = <IN>;
        close IN or warn "cannot close file: $!";
    }
    if (defined $out) {
        die "file not found: $!" unless -f $out;
        sysopen OUT, $out, O_CREAT|O_WRONLY or 
          die "cannot open file: $!";
    }
    else {
        *OUT = *STDOUT;
    }
    
    #print STDERR $source;
    my $rc = $parser->begin($source);
    
    close OUT or warn "cannot write to file: $!" unless 
      fileno(OUT) == fileno(STDOUT);
    unlink $out if not defined $rc and defined $out and -f $out;
    exit 0;
}

main(@ARGV);
__DATA__
# focus on:
# Level 1: class, typedef, function, enum, union
# Level 2: template
# 
# which are relavant to make binding
# loop structure
begin : loop
loop  : ( 
           typedef(s) 
         | comment(s) 
         | enum(s)
         | template(s)
        ) loop
# keywords
keyword_class    : 'class'
keyword_typedef  : 'typedef'
keyword_comment  : '#'
keyword_template : 'template'
keyword_enum     : 'enum'
keyword_union    : 'union'
# primitive code blocks
comment  : keyword_comment /.*?$/mio 
           { print $item[1], " ", $item[2], "\n" }
# FIXME: typedef anonymous enum|union|class
typedef  : keyword_typedef /(?>[^;]+)/sio ';'  
           { print $item[1], " ", $item[2], " ", $item[3], "\n" }
enum     : keyword_enum enum_name enum_body ';'
# container code blocks
template : keyword_template '<' template_typename '>' template_body ';'
class    : keyword_class class_name class_inheritance class_body ';'
           { print $item[1], " ", $item[2], " ", $item[3], "\n" }
# functional code blocks
until_begin_brace         : /(?>[^\{]+)/sio
                            { $return = $item[1] }
until_end_brace           : /(?>[^\}]+)/sio
                            { $return = $item[1] }
until_begin_angle_bracket : /(?>[^\<]+)/sio
                            { $return = $item[1] }
until_end_angle_bracket   : /(?>[^\>]+)/sio
                            { $return = $item[1] }
until_equals              : /(?>[^\=]+)/sio
                            { $return = $item[1] }
until_dot                 : /(?>[^\,]+)/sio
                            { $return = $item[1] }

enum_name          : until_begin_brace
                     { $return = $item[1] }
enum_body          : '{' enum_unit(s /,/) '}'
enum_unit          : until_dot 
                     { $return = (split /=/, $item[1])[0] }

template_typename  : until_end_angle_bracket 
                     { $return = $item[1] } 
                   |                
                     { $return = ''       }
template_body      : template_class 
                   | template_function
class_name         : until_begin_brace
                     { $return = $item[1] } 
class_body         : '{' class_body_content '}'
                   | 
class_body_content : 