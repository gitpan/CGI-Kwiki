package CGI::Kwiki::Prefs;
$VERSION = '0.01';
use strict;
use CGI::Kwiki;

attribute 'driver';

sub new {
    my ($class, $driver) = @_;
    my $self = bless {}, $class;
    $self->driver($driver);
    return $self;
}

sub process {
    my ($self) = @_;
    $self->driver->cgi->page_id('Preferences');
    return
      $self->driver->template->header .
      $self->driver->template->prefs_body .
      $self->driver->template->footer;
}

1;

=head1 NAME 

CGI::Kwiki::Prefs - Preferences Base Class for CGI::Kwiki

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
