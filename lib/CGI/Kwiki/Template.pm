package CGI::Kwiki::Template;
$VERSION = '0.12';
use strict;
use base 'CGI::Kwiki';

sub header {
    my ($self) = @_;
    my $page_id = $self->cgi->page_id;
    my $top_page = $self->config->top_page;
    my $kwiki_image = $self->config->kwiki_image;
    my $image_html = '';
    if (defined $kwiki_image) {
        $image_html = qq{<img src="$kwiki_image" border="0">};
    }
    my $title_prefix = $self->config->title_prefix;
    my $sister_html = '';
    <<END;
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head>
<title>$title_prefix: $page_id</title>
</head>
<body bgcolor=#FFFFFF link=#d06040 vlink=#806040>
<table width=600 cellspacing=0 cellpadding=3>
<tr>
<td align=center valign=top width=90>
<a href="?$top_page">
$image_html
</a>
$sister_html
</td>
<td width=510 valign=center>
<h1>
<a href="index.cgi?action=search&search=$page_id">
$page_id
</a>
</h1>
<form method="post" action="index.cgi"
      enctype="application/x-www-form-urlencoded">
<a href="index.cgi?$top_page">$top_page</a> | 
<a href="index.cgi?RecentChanges">RecentChanges</a> | 
<!-- <a href="index.cgi?action=prefs">Preferences</a> | -->
Search: 
<input type="text" name="search" size="15" />
<input type="hidden" name="action" value="search" />
</form>
</td>
</tr><tr>
<td align=center valign=top><font size=-1><br></font></td>
<td>
<hr>
END
}

sub footer {
    my ($self) = @_;
    <<END;
</body>
</html>
END
}

sub display_footer {
    my $self = shift;
    my $page_id = $self->cgi->page_id;
<<END;
<p>&nbsp;</td>
</tr><tr>
<td align=center>
<form>
<input type="submit" value="EDIT">
<input type="hidden" name="action" value="edit">
<input type="hidden" name="page_id" value="$page_id">
</form>
</td>
<td align=left valign=top>

</td>
</tr>
</table>
</body>
</html>
END
}

sub edit_body {
    my ($self, $wiki_text) = @_;
    my $page_id = $self->cgi->page_id;
    return <<END;
<form method="post" 
      action="index.cgi" 
      enctype="application/x-www-form-urlencoded"
>
<input type="hidden" name="action" value="edit"></input>
<input type="hidden" name="page_id" value="$page_id" />

<textarea name="wiki_text" 
          rows=25
          cols=65 
          style="width:100%" 
          wrap="virtual">$wiki_text</textarea>
<br><br>
<input type="submit" name="button" value="SAVE" />
<input type="submit" name="button" value="PREVIEW" />
</form>
END
}

sub display_body {
    my ($self, $display) = @_;
    return "<wiki>\n$display</wiki>\n";
}

sub preview_body {
    my ($self, $preview) = @_;
    <<END;
<hr>
<h2>Preview:</h2>
$preview
END
}

1;

=head1 NAME 

CGI::Kwiki::Template - Template Base Class for CGI::Kwiki

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
