package CGI::Kwiki::Edit;
$VERSION = '0.16';
use strict;
use base 'CGI::Kwiki', 'CGI::Kwiki::Privacy';
use CGI::Kwiki ':char_classes';

use constant NEW_DEFAULT => '- New Page Name -';

my $error_msg;

sub process {
    my ($self) = @_;
    return $self->protected 
      unless $self->is_editable;
    $error_msg = '';
    my $page_id = $self->cgi->page_id;
    $self->cgi->page_id_new($self->cgi->page_id_new || NEW_DEFAULT);
    my $page_id_new = $self->cgi->page_id_new;
    if (length $page_id_new and
        $page_id_new ne NEW_DEFAULT
       ) {
        if ($page_id_new !~ /^[$ALPHANUM\:\-]+$/) {
            $error_msg = 
              qq{<font color="red">Invalid page name '$page_id_new'</font>};
        }
        elsif ($self->driver->database->exists($page_id_new)) {
            $error_msg =
              qq{<font color="red">Page name '$page_id_new' already exists</font>};
        }
        else {
            $self->cgi->page_id($page_id_new);
        }
    }
    return $self->save 
      if $self->cgi->button =~ /^save$/i and not $error_msg;
    return $self->preview 
      if $self->cgi->button =~ /^preview$/i;
    $self->driver->load_class('backup');
    my $wiki_text = ($self->cgi->revision && 
                     $self->cgi->revision ne $self->cgi->head_revision
                    )
        ? $self->driver->backup->fetch($page_id, $self->cgi->revision)
        : $self->driver->database->load;
    $self->template->process(
        [qw(display_header edit_body basic_footer)],
        wiki_text => $wiki_text,
        error_msg => $error_msg,
        history => $self->history,
        $self->privacy_checked,
    );
}

sub history {
    my ($self) = @_;
    return '' unless $self->driver->backup->has_history;
    my $changes = $self->driver->backup->history;
    return '' unless @$changes;
    my $selected_revision = $self->cgi->revision || $changes->[0]->{revision};
    my $head_revision = $changes->[0]->{revision};
    my $history = <<END;
<br>
<input type="hidden" name="head_revision" value="$head_revision">
<select name="revision" onchange="this.form.submit()">
END
    for my $change (@$changes) {
        my $selected = $change->{revision} eq $selected_revision
          ? ' selected' : '';
        my ($revision, $date, $edit_by) =
          @{$change}{qw(revision date edit_by)};
        $history .= qq{<option value="$revision"$selected>} .
                    qq{$revision ($date) $edit_by</option>\n};
    }
    $history .= qq{</select>\n};
}

sub privacy_checked {
    my ($self) = @_;
    return (
        public_checked => $self->is_public ? ' checked' : '',
        protected_checked => $self->is_protected ? ' checked' : '',
        private_checked => $self->is_private ? ' checked' : '',
    );
}

sub protected {
    my ($self) = @_;
    $self->template->process(
        [qw(display_header protected_edit_body basic_footer)],
    );
}

sub preview {
    my ($self) = @_;
    $self->driver->load_class('formatter');
    my $wiki_text = $self->cgi->wiki_text;
    my $preview = $self->driver->formatter->process($wiki_text);
    $self->template->process(
        [qw(display_header preview_body edit_body basic_footer)],
        preview => $preview,
        error_msg => $error_msg,
        $self->privacy_checked,
    );
}

sub save {
    my ($self) = @_;
    my $wiki_text = $self->cgi->wiki_text;
    $self->driver->database->store($wiki_text);
    if ($self->is_admin) {
        my $privacy = $self->cgi->privacy || 'public';
        $self->set_privacy($privacy);
        $self->blog if $self->cgi->blog;
        $self->delete if $self->cgi->delete;
    }
    return { redirect => $self->script . "?" . $self->cgi->page_id };
}

sub blog {
    my ($self) = @_;
    $self->driver->load_class('blog');
    $self->driver->blog->create_entry;
}

sub delete {
    my ($self) = @_;
    $self->driver->database->delete;
    $self->cgi->page_id('');
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
