package CGI::Kwiki::Database;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';

sub exists {
    my ($self, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
    return -f "database/$page_id";
}

sub load {
    my ($self, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
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
    my $file_path = "database/$page_id";
    umask 0000;
    open WIKIPAGE, "> $file_path"
      or die "Can't open $file_path for output:\n$!";
    print WIKIPAGE $wiki_text;
    close WIKIPAGE;

    $self->driver->load_class('metadata');
    $self->driver->metadata->set($page_id);
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
