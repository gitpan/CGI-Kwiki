package CGI::Kwiki::Template;
$VERSION = '0.15';
use strict;
use base 'CGI::Kwiki';

CGI::Kwiki->rebuild if @ARGV and $ARGV[0] eq '--rebuild';

sub directory { 'template' }
sub suffix { '.html' }

sub process {
    my ($self, $template_file, %vars) = @_;
    $template_file = "template/$template_file.html";
    open TEMPLATE, $template_file
      or die "Can't open $template_file for input\n";
    my $template = do {local $/; <TEMPLATE>};
    close TEMPLATE;
    return $self->render($template,
        $self->config->all,
        $self->cgi->all,
        %vars,
    );
}

sub display_vars {
    my ($self) = @_;
    my %vars;
    $vars{image_html} = 
      '<h1><a href="index.cgi?KwikiLogoImage">???</a></h1>';
    if (defined $self->config->kwiki_image) {
        my $kwiki_image = $self->config->kwiki_image;
        $vars{image_html} = qq{<img src="$kwiki_image" border="0">};
    }
    $vars{sister_html} = '';
    return %vars;
}

1;

__DATA__

=head1 NAME 

CGI::Kwiki::Template - HTML Template Base Class for CGI::Kwiki

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

__basic_footer__
</body>
</html>
__display_body__
<wiki>
[% display %]
</wiki>
__display_footer__
<p>&nbsp;</td>
</tr><tr>
<td align=center>
<form>
<input type="submit" value="EDIT">
<input type="hidden" name="action" value="edit">
<input type="hidden" name="page_id" value="[% page_id %]">
</form>
</td>
<td align=left valign=top>

</td>
</tr>
</table>
</body>
</html>
__display_header__
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head>
<title>[% title_prefix %]: [% page_id %]</title>
<link rel="stylesheet" type="text/css" href="css/Display.css">
<!-- <script src="javascript/Display.js"></script> -->
</head>
<body bgcolor=#FFFFFF link=#d06040 vlink=#806040>
<table width=600 cellspacing=0 cellpadding=3>
<tr>
<td align=center valign=top width=90>
[% image_html %]
[% sister_html %]
</td>
<td width=510 valign=center>
<h1>
<a href="index.cgi?action=search&search=[% page_id %]">
[% page_id %]
</a>
</h1>
<form method="post" action="index.cgi"
      enctype="application/x-www-form-urlencoded">
<a href="index.cgi?[% top_page %]">[% top_page %]</a> | 
<a href="index.cgi?RecentChanges">RecentChanges</a> | 
<a href="index.cgi?action=prefs">Preferences</a> |
<input type="text" name="search" size="15" value="Search"
       onfocus="this.value=''" />
<input type="hidden" name="action" value="search" />
</form>
</td>
</tr><tr>
<td align=center valign=top><font size=-1><br></font></td>
<td>
<hr>
__edit_body__
<form method="post" 
      action="index.cgi" 
      enctype="application/x-www-form-urlencoded"
>
<input type="hidden" name="action" value="edit"></input>
<input type="hidden" name="page_id" value="[% page_id %]" />

<textarea name="wiki_text" 
          rows=25
          cols=65 
          style="width:100%" 
          wrap="virtual">[% wiki_text %]</textarea>
<br><br>
<table border="0">
<tr><td align="right">
<input type="submit" name="button" value="SAVE" />
<td>
<input type="text" name="page_id_new" value="[% page_id_new %]" 
       onfocus="this.value=''" />
<td>
[% error_msg %]
<tr><td align="right">
<input type="submit" name="button" value="PREVIEW" />
<td colspan="2">&nbsp;
</table>
</form>
__prefs_body__
<form>
<p>Your <a href="index.cgi?KwikiUserName">KwikiUserName</a> will be used
   to indicate who changed a page. This can be viewed in <a
   href="index.cgi?RecentChanges">RecentChanges</a>.
</p>
<font color="red">[% error_msg %]</font>
UserName: &nbsp;
<input type="text" name="user_name" value="[% user_name %]" size="20" /> 
<br><br>
<input type="submit" name="button" value="SAVE" />
<input type="hidden" name="action" value="prefs" />
</form>
__preview_body__
<hr>
<h2>Preview:</h2>
[% preview %]
__slide_page__
<html>
<head>
<title>KwikiSlides - [% page_id %]</title>
<link rel="stylesheet" type="text/css" href="css/SlideShow.css">
<script src="javascript/SlideShow.js"></script>
</head>
<body>
<table width="100%" border="0" cellpadding="5" cellspacing="0">
<tr bgcolor="#E0E0FF"><td colspan="3" align="center" valign="middle">
<h4>[% title %]</h4>
<tr>
<td width="5%">
&nbsp;
<td width="90%">
[% slide %]
<td width="5%">
&nbsp;
</table>
<form method="POST" action="index.cgi">
<input type="hidden" name="slide_num" value="[% slide_num %]">
<input type="hidden" name="action" value="slides">
<input type="hidden" name="page_id" value="[% page_id %]">
</form>
</body>
</html>
