package CGI::Kwiki::Display;
$VERSION = '0.16';
use strict;
use base 'CGI::Kwiki', 'CGI::Kwiki::Privacy';

sub process {
    my ($self) = @_;
    my $page_id = $self->cgi->page_id;
    if (not $self->is_readable) {
        return {redirect => $self->script . '?KwikiPrivatePage'};
    }
    return $self->changes if $page_id eq 'RecentChanges';
    return $self->edit unless $self->driver->database->exists;
    my $wiki_text = $self->driver->database->load;
    my $formatted = $self->driver->formatter->process($wiki_text);
    $self->template->process(
        [qw(display_header display_body display_footer)],
        display => $formatted,
        is_editable => $self->is_editable,
    );
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

__END__

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
