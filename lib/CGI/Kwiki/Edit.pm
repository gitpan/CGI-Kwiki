package CGI::Kwiki::Edit;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';
use CGI::Kwiki ':char_classes';

use constant NEW_DEFAULT => '- New Page Name -';

my $error_msg;

sub process {
    my ($self) = @_;
    $error_msg = '';
    $self->cgi->page_id_new($self->cgi->page_id_new || NEW_DEFAULT);
    my $page_id_new = $self->cgi->page_id_new;
    if (length $page_id_new and
        $page_id_new ne NEW_DEFAULT and
        $page_id_new !~ /^[$ALPHANUM\:\-]+$/
       ) {
        $error_msg = 
          qq{<font color="red">Invalid page name '$page_id_new'</font>};
    }
    else {
        return $self->save 
          if $self->cgi->button =~ /^save$/i;
    }
    return $self->preview 
      if $self->cgi->button =~ /^preview$/i;
    my $wiki_text = $self->driver->database->load;
    return
      $self->template->process('display_header',
          $self->template->display_vars,
      ) .
      $self->template->process('edit_body', 
          wiki_text => $wiki_text,
          error_msg => $error_msg,
      ) .
      $self->template->process('basic_footer');
}

sub preview {
    my ($self) = @_;
    $self->driver->load_class('formatter');
    my $wiki_text = $self->cgi->wiki_text;
    my $preview = $self->driver->formatter->process($wiki_text);
    return
      $self->template->process('display_header',
          $self->template->display_vars,
      ) .
      $self->template->process('edit_body',
          error_msg => $error_msg,
      ) .
      $self->template->process('preview_body',
          preview => $preview,
      ) .
      $self->template->process('basic_footer');
}

sub save {
    my ($self) = @_;
    my $page_id_new = $self->cgi->page_id_new;
    if (length $page_id_new and
        $page_id_new ne NEW_DEFAULT
       ) {
        $self->cgi->page_id($page_id_new);
    }
    my $wiki_text = $self->cgi->wiki_text;
    $self->driver->database->store($wiki_text);
    return { redirect => "index.cgi?" . $self->cgi->page_id };
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
