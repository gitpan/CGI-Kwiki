#!/usr/bin/perl -w

$VERSION = '0.10';
use strict;

BEGIN {
    my $arg = shift(@ARGV) || '';
    if ($arg eq '--install') {
        require CGI::Kwiki::New;
        CGI::Kwiki::New->new->create_kwiki;
        exit(0);
    }
    elsif ($arg =~ /^-/) {
        die "Unknown argument '$arg' for kwiki.cgi\n";
    }
}

use CGI::Kwiki;
CGI::Kwiki::run_cgi();

__END__

=head1 NAME

kwiki.cgi - The cgi-bin component for CGI::Kwiki

=head1 USAGE

    > mkdir cgi-bin/my-kwiki
    > cd cgi-bin/my-kwiki
    > kwiki.cgi --install

    Kwiki software installed! Point your browser at this location.

=head1 DESCRIPTION

CGI::Kwiki is a simple extendable wiki framework, written in Perl.

=head1 AUTHOR

Brian Ingerson <INGY@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2003. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut

# vim: set ft=perl:
