package CGI::Kwiki::Template;
$VERSION = '0.17';
use strict;
use base 'CGI::Kwiki', 'CGI::Kwiki::Privacy';

CGI::Kwiki->rebuild if @ARGV and $ARGV[0] eq '--rebuild';

sub directory { 'template' }
sub suffix { 
    my ($self, $file) = @_;
    $file =~ /README/ ? '' : '.html';
}

sub process {
    my ($self, $template, %vars) = @_;
    my @vars = (
        $self->config->all,
        $self->cgi->all,
        $self->all,
        $self->display_vars,
        %vars,
    );
    my @templates = ref $template ? @$template : $template;
    return join '', map 
    {
        $self->render($self->read_template($_), @vars)
    } @templates;
}

sub read_template {
    my ($self, $template) = @_;
    my $template_file = -f "template/local/$template.html"
      ? "template/local/$template.html"
      : "template/$template.html";
    open TEMPLATE, $template_file
      or die "Can't open $template_file for input\n";
    my $template_text = do {local $/; <TEMPLATE>};
    close TEMPLATE;
    return $template_text;
}

sub display_vars {
    my ($self) = @_;
    my %vars;
    $vars{image_html} = 
      '<h1><a href="' . $self->script . '?KwikiLogoImage">???</a></h1>';
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

__README__
Any templates that you modify should be copied to a "template/local/"
directory first. This will keep them from being clobbered by upgrades to
CGI::Kwiki. CGI::Kwiki automatically looks for templates in the
template/local/ directory before searching the template/ directory.
__basic_footer__
</td>
</tr>
</table>
</body>
</html>
__blog_entry__
<table width="100%" bgcolor="#e0e0e0">
    <tr>
    <td><a href="blog.cgi?[% blog_id %]">[% blog_date %]</a></td>
    <td align="right"><a href="kwiki.cgi?[% page_id %]">[% page_id %]</a></td>
    </tr>
</table>
[% entry_text %]
__blog_footer__
</td>
</tr>
</table>
</body>
</html>
__blog_header__
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head>
<title>[% title_prefix %]: Blog</title>
<link rel="stylesheet" type="text/css" href="css/Display.css">
<!-- <script src="javascript/Blog.js"></script> -->
</head>
<body>
<table border="0" width="600" cellspacing="0" cellpadding="3">
<tr>
<td align="center" valign="top" width="90">
[% image_html %]
</td>
<td align="left" valign="center" width="510">
<h1><a href="blog.cgi">Kwiki Blog</a></h1>
</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>
__display_body__
<wiki>
[% display %]
</wiki>
__display_footer__
<p>&nbsp;</td>
</tr><tr>
<td align=center>
[% IF is_editable %]
<form>
<input type="submit" value="EDIT">
[% ELSE %]
<form action="admin.cgi">
<input type="submit" value="LOGIN">
[% END %]
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- <script src="javascript/Display.js"></script> -->
</head>
<body>
<table width="600" cellspacing="0" cellpadding="3">
<tr>
<td align="center" valign="top" width="90">
[% image_html %]
[% sister_html %]
</td>
<td align="left" valign="top" width="510">
<h1>
<a href="[% script %]?action=search&search=[% page_id %]">
[% page_id %]
</a>
</h1>
<form method="post" action="[% script %]"
      enctype="application/x-www-form-urlencoded">
<a href="[% script %]?[% top_page %]">[% top_page %]</a> | 
[% IF has_privacy %]
<a href="blog.cgi">Blog</a> |
[% END %]
<a href="[% script %]?RecentChanges">RecentChanges</a> | 
<a href="[% script %]?action=prefs">Preferences</a> |
<input type="text" name="search" size="15" value="Search"
       onfocus="this.value=''" />
<input type="hidden" name="action" value="search" />
</form>
</td>
</tr><tr>
<td>&nbsp;</td>
<td>
<hr>
__edit_body__
<script src="javascript/Edit.js"></script>
<form method="post" 
      action="[% script %]" 
      enctype="application/x-www-form-urlencoded">
<input type="hidden" name="action" value="edit">
<input type="hidden" name="page_id" value="[% page_id %]">
<input type="submit" name="button" value="SAVE">
<input type="text" name="page_id_new" value="[% page_id_new %]" 
       size="16" onfocus="this.value=''">
<input type="submit" name="button" value="PREVIEW">
<br>
[% IF error_msg %]
<br>
[% error_msg %]
[% END %]
<br>
[% IF is_admin %]
<br>
<input type="radio" name="privacy" value="public"[% public_checked %]>
<b>Public</b>
<input type="radio" name="privacy" value="protected"[% protected_checked %]>
<b>Protected</b>
<input type="radio" name="privacy" value="private"[% private_checked %]>
<b>Private</b><br>
[% END %]

<textarea name="wiki_text" 
          rows="25"
          cols="65" 
          style="width:100%" 
          wrap="virtual"
>[% wiki_text %]</textarea>
<br>
[% history %]
<br>
[% IF is_admin %]
<br>
<input type="checkbox" name="blog"
       onclick="setProtected(this)">
<b>Blog this page on SAVE</b><br>
<input type="checkbox" name="delete"
       onclick="setForDelete(this)">
<b>Permanently delete this page on SAVE</b><br>
[% END %]
</form>
[% IF not_admin %]
<form method="post" 
      action="admin.cgi" 
      enctype="application/x-www-form-urlencoded">
<input type="hidden" name="action" value="edit">
<input type="hidden" name="page_id" value="[% page_id %]">
<input type="submit" name="button" value="LOGIN">
</form>
[% END %]
__prefs_body__
<form>
<p>Your <a href="[% script %]?KwikiUserName">KwikiUserName</a> will be used
   to indicate who changed a page. This can be viewed in <a
   href="[% script %]?RecentChanges">RecentChanges</a>.
</p>
<font color="red">[% error_msg %]</font>
UserName: &nbsp;
<input type="text" name="user_name" value="[% user_name %]" size="20"> 
<br><br>
<input type="submit" name="button" value="SAVE">
<input type="hidden" name="action" value="prefs">
</form>
__preview_body__
[% preview %]
<hr>
__protected_edit_body__
<b>This is a protected page. Only the site administrator can edit it.</b>
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
<form method="POST" action="[% script %]">
<input type="hidden" name="slide_num" value="[% slide_num %]">
<input type="hidden" name="action" value="slides">
<input type="hidden" name="page_id" value="[% page_id %]">
</form>
</body>
</html>
