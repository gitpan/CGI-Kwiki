package CGI::Kwiki::Slides;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';

sub process {
    my ($self) = @_;
    my %vars;
    my $wiki_text = $self->driver->database->load;
    my @slides = split "----\n", $wiki_text;
    my $slide_num = $self->cgi->slide_num || 1;
    $slide_num = $#slides if $slide_num >= @slides;
    $slide_num = 1 if $slide_num <= 0;
    my $formatter = CGI::Kwiki::Slides::Formatter->new($self->driver);
    $vars{slide} = $formatter->process($slides[$slide_num]);
    my %config = $slides[0] =~ /^#\s*(.*?)\s*: \s*(.*?)\s*$/mg;
    $vars{title} = $config{title} || "Title Goes Here";
    $vars{slide_num} = $slide_num;

    return $self->driver->template->process('slide_page', %vars);
}

package CGI::Kwiki::Slides::Formatter;
use base 'CGI::Kwiki::Formatter';

sub process_order {
    return qw(
        table 
        code 
        escape_html
        header_1 header_2 header_3 
        lists comment horizontal_line
        paragraph 
        named_http_link no_http_link http_link
        bold italic underscore
    );
}

# XXX - Use Stylesheet
sub code_postformat {
    my ($self, $text) = @_;
    return <<END;
<blockquote>
<table bgcolor="lightyellow" cellspacing="5"><tr><td>
<pre>$text</pre>
</table>
</blockquote>
END
}

1;

__END__

=head1 NAME 

CGI::Kwiki::Slides - Slide Show Plugin for CGI::Kwiki

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
