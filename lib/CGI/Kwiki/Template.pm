package CGI::Kwiki::Template;
$VERSION = '0.11';
use strict;
use CGI::Kwiki;

attribute 'driver';

sub new {
    my ($class, $driver) = @_;
    my $self = bless {}, $class;
    $self->driver($driver);
    return $self;
}

sub header {
    my ($self) = @_;
    my $page_id = $self->driver->cgi->page_id;
    my $top_page = $self->driver->config->top_page;
    my $kwiki_image = $self->driver->config->kwiki_image;
    my $image_html = '';
    if (defined $kwiki_image) {
        $image_html = 
          qq{<img src="$kwiki_image" alt="[$top_page]" border=0 align="right">};
    }
    my $title_prefix = $self->driver->config->title_prefix;
    <<END;
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head>
<title>$title_prefix: $page_id</title>
</head>
<body BGCOLOR="white">
<h1>
    <a href="?$top_page">
    $image_html
    </a>
    <a href="index.cgi?action=search&search=$page_id">$page_id</a>
</h1>
<form method="post" action="index.cgi"
      enctype="application/x-www-form-urlencoded">
<a href="index.cgi?$top_page">$top_page</a> | 
<a href="index.cgi?RecentChanges">RecentChanges</a> | 
<a href="index.cgi?action=prefs">Preferences</a> |
Search: 
<input type="text" name="search" size="20" />
<input type="hidden" name="action" value="search" />
</form>
<hr>
END
}

sub footer {
    my ($self) = @_;
    <<END;
<hr>
</body>
</html>
END
}

sub display_footer {
    my ($self) = @_;
    my $page_id = $self->driver->cgi->page_id;
    <<END;
<hr>
<form>
<input type="submit" value="EDIT">
<input type="hidden" name="action" value="edit">
<input type="hidden" name="page_id" value="$page_id">
</form>
</body>
</html>
END
}

sub edit_body {
    my ($self, $wiki_text) = @_;
    my $page_id = $self->driver->cgi->page_id;
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
<br><br>
(Visit <a href="index.cgi?action=prefs">Preferences</a> 
to set your user name.) 
</form>
END
}

sub display_body {
    my ($self, $body) = @_;
    return $body;
}

sub preview_body {
    my ($self, $preview) = @_;
    <<END;
<hr>
<h2>Preview:</h2>
$preview
END
}

sub search_body {
    my ($self, $result) = @_;
    return $result;
}

sub changes_body {
    my ($self, $result) = @_;
    return $result;
}

sub prefs_body {
    my ($self) = @_;
<<END;
<form>
<br>
UserName: &nbsp;
<input type="text" name="user_name" size="20" /> 
<br><br>
<input type="submit" name="button" value="ENTER" />
<input type="hidden" name="action" value="prefs" />
</form>
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
