package CGI::Kwiki::Slides;
$VERSION = '0.13';
use strict;
use base 'CGI::Kwiki';

sub process {
    my ($self) = @_;
    my $page_id = $self->cgi->page_id;
    my $wiki_text = $self->driver->database->load($page_id);
    my @slides = split /^-{4,}$/m, $wiki_text;
    my $slide_num = $self->cgi->slide_num || 1;
    $slide_num = $#slides if $slide_num >= @slides;
    $slide_num = 1 if $slide_num <= 0;
    my $formatter = CGI::Kwiki::Slides::Formatter->new($self->driver);
    my $slide = $formatter->process($slides[$slide_num]);
    my %config = $slides[0] =~ /^#\s*(.*?)\s*: \s*(.*?)\s*$/mg;
    my $title = $config{title} || "Title Goes Here";
    <<END;
<html>
<head>
<title>KwikiSlides - $page_id</title>
<style>
pre { font-family: courier, monospace; font-weight: bolder }
li { font-size: 20pt; padding-top: 10 }
</style>
<script>

function xxx(x) {
    alert("Value is ->" + x + "<-");
}

function incrementSlide(i) {
    var myForm = document.getElementsByTagName("form")[0];
    var myNum = myForm.getElementsByTagName("input")[0];
    i = i * 1;
    myVal = myNum.value * 1;
    myNum.value = myVal + i;
    myForm.submit();
}

function gotoSlide(i) {
    var myForm = document.getElementsByTagName("form")[0];
    var myNum = myForm.getElementsByTagName("input")[0];
    myNum.value = i;
    myForm.submit();
}

function nextSlide() {
    incrementSlide(1);
}

function prevSlide() {
    incrementSlide(-1);
}

function handleKey(e) {
    var key;
    if (e == null) {
        // IE
        key = event.keyCode;
    } 
    else {
        // Mozilla
        if (e.altKey || e.ctrlKey) {
            return true;
        }
        key = e.which;
    }
    switch(key) {
        case 8: prevSlide(); break;
        case 13: nextSlide(); break;
        case 32: nextSlide(); break;
        case 49: gotoSlide(1); break;
        case 113: window.close(); break;
        default: //xxx(e.which)
    }
}

document.onkeypress=handleKey;
document.onclick=nextSlide;
document.ondblclick=prevSlide;

</script>
</head>
<body>
<table width="100%" border="0" cellpadding="5" cellspacing="0">
<tr bgcolor="#E0E0FF"><td colspan="3" align="center" valign="middle">
<h4>$title</h4>
<tr>
<td width="5%">
&nbsp;
<td width="90%">
$slide
<td width="5%">
&nbsp;
</table>
<form method="POST" action="index.cgi">
<input type="hidden" name="slide_num" value="$slide_num">
<input type="hidden" name="action" value="slides">
<input type="hidden" name="page_id" value="$page_id">
</form>
</body>
</html>
END
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
