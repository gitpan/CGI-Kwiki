package CGI::Kwiki::Changes;
$VERSION = '0.16';
use strict;
use base 'CGI::Kwiki', 'CGI::Kwiki::Privacy';

sub process {
    my ($self) = @_;
    $self->driver->load_class('metadata');
    my $search = $self->cgi->page_id;
    return
      $self->template->process(
          'display_header',
          $self->template->display_vars,
      ) .
      $self->changes .
      $self->template->process('basic_footer');
}

sub changes {
    my ($self) = @_;
    my $search = $self->cgi->search;
    my $pages = [ 
        map {[$_, -M $_]} 
        grep {
            (my $page_id = $_) =~ s/.*[\/\\]//;
            $self->is_readable($page_id);
        } glob "database/*" 
    ];
    my $html = qq{<table border="0">\n};
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
            $html .= qq{<tr><td colspan="3"><h2>Changes in the last $range->[0]:</h2>\n};
            for my $page_id (sort {-M $a <=> -M $b} 
                             map {$_->[0]} @$recent) {
                $html .= "<tr>\n";
                $page_id =~ s/.*[\/\\](.*)/$1/;
                my $metadata = $self->driver->metadata->get($page_id);
                my $edit_by = $metadata->{edit_by} || '&nbsp;';
                $html .= qq{<td><a href="?$page_id">$page_id</a>\n};
                $html .= qq{<td>&nbsp;<td>$edit_by\n};
            }
        }
    }
    return $html;
}

1;

__END__

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
