package CGI::Kwiki::Search;
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
    my $search = $self->driver->cgi->page_id;
    return
      $self->driver->template->header .
      $self->driver->template->search_body($self->search) .
      $self->driver->template->footer;
}

sub search {
    my ($self) = @_;
    my $search = $self->driver->cgi->search;
    # Detaint query string
    $search =~ s/[^\w\ \-\.\^\$\*\|]//g;
    my @results = `grep -lir '$search' database`;
    my $result = '<h2>' . @results . " pages found:</h2>\n";
    for my $page_id (sort @results) {
        $page_id =~ s/.*?(\w+)\n/$1/;
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
