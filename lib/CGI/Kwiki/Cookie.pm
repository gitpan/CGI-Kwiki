package CGI::Kwiki::Cookie;
$VERSION = '0.12';
use strict;
use base 'CGI::Kwiki';
use CGI::Kwiki;
use CGI();

attribute 'prefs';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->prefs($self->fetch);
    return $self;
}

sub header {
    my ($self) = @_;
    my $cookie = $self->create;
    return CGI::header(
        -cookie => $cookie,
    );
}

sub create{
    my ($self) = @_;
    return CGI::cookie('prefs', $self->prefs);
}

sub fetch {
    my ($self) = @_;
    return { CGI::cookie('prefs') };
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
