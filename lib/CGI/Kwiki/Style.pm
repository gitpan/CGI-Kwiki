package CGI::Kwiki::Style;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';

CGI::Kwiki->rebuild if @ARGV and $ARGV[0] eq '--rebuild';

sub directory { 'css' }
sub suffix { '.css' }

1;

__DATA__

=head1 NAME 

CGI::Kwiki::Style - Default Stylesheets for CGI::Kwiki

=head1 DESCRIPTION

See installed kwiki pages for more information.

=head1 AUTHOR

Brian Ingerson <INGY@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2003. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut

__Display__
a {text-decoration:none}
a.empty {text-decoration:line-through}
__Scratch__
/*
 * Comment
 * lines
*/

body { font-family: Geneva,Arial,Helvetica,sans-serif; font-size: 10pt; }
h1   { font-size: 18pt; font-style: bold; align: center; }
h2   { font-size: 14pt; font-style: bold; align: center; }
h3   { font-size: 14pt; font-style: bold; }
h4   { font-size: 12pt; font-style: bold; }
p.moddate { font-size: 9pt; }

td { font-family: Geneva,Arial,Helvetica,sans-serif; font-size: 12pt; 
     vertical-align: text-top; }
td.side { background-color: #333399; color: #ffffff; font-size: 10pt;
          vertical-align: text-top;}
td.venue { background-color: #ffffff; color: #000000; font-size: 10pt; 
           text-align: center; }   /* venue announcement in side column */
td.header { text-align: center; }  /* yapc logo header */

a { color: #0000FF; text-decoration: underline; }
a:visited { color: #FF00FF; text-decoration: underline; }
a:hover { color: #0000FF; text-decoration: underline; }

a.side { color: #ffffff; text-decoration: none; }
a.side:visited { color: #ccccff; text-decoration: none; }
a.side:hover { color: #ffffff; text-decoration: underline; }

a.sidehead { color: #ffffff; text-decoration: underline; font-weight: bold;}
a.sidehead:visited { color: #ffccff; text-decoration: underline; font-weight: bold;}
a.sidehead:hover { color: #ffffff; text-decoration: underline; font-weight: bold;}
__SlideShow__
pre { font-family: courier, monospace; font-weight: bolder }
li  { font-size: 20pt; padding-top: 10 }

