package CGI::Kwiki::Search;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';
use CGI::Kwiki ':char_classes';

sub process {
    my ($self) = @_;
    my $search = $self->cgi->page_id;
    return
      $self->template->process(
          'display_header',
          $self->template->display_vars,
      ) .
      $self->search .
      $self->template->process('basic_footer');
}

sub search {
    my ($self) = @_;
    my $database = $self->driver->database;
    my $search = $self->cgi->search;
    # Detaint query string
    $search =~ s/[^$WORD\ \-\.\^\$\*\|\:]//g;
    my @pages = $self->driver->database->pages;
    my @results;
    for my $page_id (@pages) {
        if ($page_id =~ m{$search}i) {
            push @results, $page_id;
            next;
        }
        my $wiki_text = $database->load($page_id);
        if ($wiki_text =~ m{$search}is) {
            push @results, $page_id;
        }
    }
    my $result = '<h2>' . @results . 
                 " pages found containing '$search':</h2>\n";
    for my $page_id (sort @results) {
        $page_id =~ s/.*?([$WORD\-:]+)\n/$1/;
        $result .= qq{<a href="?$page_id">$page_id</a><br>\n};
    }
    return $result;
}

1;

=head1 NAME 

CGI::Kwiki::Search - Search Base Class for CGI::Kwiki

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
