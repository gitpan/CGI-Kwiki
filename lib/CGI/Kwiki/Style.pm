package CGI::Kwiki::Style;
$VERSION = '0.16';
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

__Blog__
a         {text-decoration: none}
__Display__
a         {text-decoration: none}
a.empty   {color: gray}
a.private {color: black}
__SlideShow__
pre { font-family: courier, monospace; font-weight: bolder }
li  { font-size: 20pt; padding-top: 10 }

