package CGI::Kwiki::Edit;
$VERSION = '0.12';
use strict;
use base 'CGI::Kwiki';

sub process {
    my ($self) = @_;
    return $self->save 
      if $self->cgi->button =~ /^save$/i;
    return $self->preview 
      if $self->cgi->button =~ /^preview$/i;
    my $page_id = $self->cgi->page_id;
    my $wiki_text = $self->driver->database->load;
    return
      $self->template->header .
      $self->template->edit_body($wiki_text) .
      $self->template->footer;
}

sub preview {
    my ($self) = @_;
    $self->driver->load_class('formatter');
    my $page_id = $self->cgi->page_id;
    my $wiki_text = $self->cgi->wiki_text;
    my $preview = $self->driver->formatter->process($wiki_text);
    return
      $self->template->header .
      $self->template->edit_body($wiki_text) .
      $self->template->preview_body($preview) .
      $self->template->footer;
}

sub save {
    my ($self) = @_;
    my $page_id = $self->cgi->page_id;
    my $wiki_text = $self->cgi->wiki_text;
    $self->driver->database->store($page_id, $wiki_text);

    return { redirect => "?$page_id" };
}

1;

=head1 NAME 

CGI::Kwiki::Edit - Edit Base Class for CGI::Kwiki

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
