package CGI::Kwiki::Display;
$VERSION = '0.11';
use strict;
use CGI::Kwiki;

attribute 'driver';

sub new {
    my ($class, $driver) = @_;
    my $self = bless {}, $class;
    $self->driver($driver);
    $self->driver->load_class('formatter');
    return $self;
}

sub process {
    my ($self) = @_;
    my $page_id = $self->driver->cgi->page_id;
    return $self->changes if $page_id eq 'RecentChanges';
    return $self->edit unless $self->driver->database->exists;
    my $wiki_text = $self->driver->database->load;
    my $formatted = $self->driver->formatter->process($wiki_text);
    return
      $self->driver->template->header .
      $self->driver->template->display_body($formatted) .
      $self->driver->template->display_footer;
}

sub edit {
    my ($self) = @_;
    $self->driver->load_class('edit');
    return $self->driver->edit->process;
}

sub changes {
    my ($self) = @_;
    $self->driver->load_class('changes');
    return $self->driver->changes->process;
}

1;

=head1 NAME 

CGI::Kwiki::Display - Display Base Class for CGI::Kwiki

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
