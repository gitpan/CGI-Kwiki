package CGI::Kwiki::Database;
$VERSION = '0.16';
use strict;
use base 'CGI::Kwiki';
use base 'CGI::Kwiki::Privacy';

sub exists {
    my ($self, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
    return 1 if $page_id eq 'RecentChanges';
    return $self->is_readable && -f "database/$page_id";
}

sub load {
    my ($self, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
    die "Can't load page '$page_id'. Unauthorized\n"
      unless $self->is_readable;
    my $file_path = "database/$page_id";
    if (-f $file_path) {
        local($/, *WIKIPAGE);
        open WIKIPAGE, $file_path 
          or die "Can't open $file_path for input:\n$!";
        return <WIKIPAGE>;
    }
    else {
        return "Describe the new page here.\n";
    }
}

sub store {
    my ($self, $wiki_text, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
    die "Can't store page '$page_id'. Unauthorized\n"
      unless $self->is_writable;
    my $file_path = "database/$page_id";
    umask 0000;
    open WIKIPAGE, "> $file_path"
      or die "Can't open $file_path for output:\n$!";
    print WIKIPAGE $wiki_text;
    close WIKIPAGE;

    $self->driver->load_class('metadata');
    $self->driver->metadata->set($page_id);
}

sub delete {
    my ($self, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
    for (qw(database metabase/metadata 
            metabase/public metabase/protected metabase/private
           )
        ) {
        unlink "$_/$page_id";
    }
}

sub pages {
    map {s/.*[\\\/]//; $_} glob "database/*";
}

1;

__END__

=head1 NAME 

CGI::Kwiki::Database - Database Base Class for CGI::Kwiki

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
