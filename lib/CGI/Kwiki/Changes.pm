package CGI::Kwiki::Changes;
$VERSION = '0.10';
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
      $self->driver->template->changes_body($self->changes) .
      $self->driver->template->footer;
}

sub changes {
    my ($self) = @_;
    my $search = $self->driver->cgi->search;
    my $pages = [ map {[$_, -M $_]} glob "database/*" ];
    my $html = '';
    for my $range
        (["hour", 1/24],
         ["3 hours", 0.125],
         ["6 hours", 0.25],
         ["12 hours", 0.5],
         ["24 hours", 1],
         ["2 days", 2],
         ["3 days", 3],
         ["week", 7],
         ["2 weeks", 7],
         ["month", 30],
         ["3 months", 90],
        ) {
        my ($recent, $older) = ([], []);
        push @{$_->[1] <= $range->[1] ? $recent : $older}, $_
          for @$pages;
        $pages = $older;
        if (@$recent) {
            $html .= "<h2>Changes in the last $range->[0]:</h2>\n";
            for my $page_id (sort {-M $a <=> -M $b} 
                             map {$_->[0]} @$recent) {
                $page_id =~ s/.*[\/\\](.*)/$1/;
                $html .= qq{<a href="?$page_id">$page_id</a><br>\n};
            }
        }
    }
    return $html;
}

1;

=head1 NAME 

CGI::Kwiki::Changes - Changes Base Class for CGI::Kwiki

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
