package CGI::Kwiki::Cookie;
$VERSION = '0.11';
use strict;
use CGI::Kwiki;
use CGI;

attribute 'driver';
attribute 'cookie';

sub new {
    my ($class, $driver) = @_;
    my $self = bless {}, $class;
    $self->driver($driver);
    $self->cookie(CGI::cookie($self->cookie_name));
    return $self;
}

sub header {
    my ($self) = @_;
    my $cookie = $self->create_cookie;
    return CGI::header(
        -cookie => $cookie,
    );
}

sub cookie_name {
    'none';
}

sub create_cookie {
    return;
}

1;

=head1 NAME 

CGI::Kwiki::CGI - CGI Base Class for CGI::Kwiki

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
