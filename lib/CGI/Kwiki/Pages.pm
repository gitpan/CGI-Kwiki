package CGI::Kwiki::Pages;
$VERSION = '0.15';
use strict;
use base 'CGI::Kwiki';

CGI::Kwiki->rebuild if @ARGV and $ARGV[0] eq '--rebuild';

sub directory { 'database' }

sub data {
    join '', map { s/^\^=/=/; $_ } <DATA>;
}

sub create_file {
    my ($self, $file_path, $content) = @_;
    (my $page_id = $file_path) =~ s!.*/!!;
    if ($self->driver->database->exists($page_id)) {
        my $metadata = $self->driver->metadata->get($page_id);
        return unless $metadata->{edit_by} eq 'kwiki-install';
    }
    $self->driver->database->store($content, $page_id);
}

1;

__DATA__

=head1 NAME 

CGI::Kwiki::Pages - Default Pages for CGI::Kwiki

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

__BrianIngerson__
Brian "ingy" Ingerson is a Perl devotee and [CPAN http://search.cpan.org/author/INGY/] module author. His modules include CGI::Kwiki which is the Wiki software you are presently using.

He has a dream to see the communities of all the /agile programming languages/ (Perl, Python, PHP, Ruby) working together. He is attemping to facilitate this in many ways including:

* [YAML http://www.yaml.org]
* [FreePAN http://www.freepan.org]
* [FIT http://fit.freepan.org]
* [Moss http://moss.freepan.org]

He can be contacted at:
* ingy@cpan.org
* irc://irc.freenode.net/kwiki
__HomePage__
*Congratulations*! You've created a new _Kwiki_ website.

This is the *default* home page. You should change this page /right away/.

Just click the EDIT button below.

You may also want to add a KwikiLogoImage in the config.yaml file. It will appear in the upper lefthand corner of each page.
----
If you need assistance on using a Kwiki first, check out KwikiHelpIndex.
__KwikiAbout__
CGI::Kwiki is simple yet powerful Wiki environment written in Perl as a CPAN module distribribution. It was written by BrianIngerson.

*This is CGI::Kwiki Version [#.#]* 

Changes in this release:
  - Support unicode character classes in page names
  - Search searches page names
  - Search is written in Perl now, instead of grep
  - Cookies span sessions
  - Allow ftp:// and irc:// links
  - Allow to create a new page from an old one
  - Dead wiki links use <strike>
  - Stop links from being underlined
  - Allow Wiki links like KWiki
  - Support <H4> <H5> and <H6>
  - Refactored installation and upgrade process
  - Added [#.#] format for $CGI::Kwiki::VERSION

Changes for version 0.14:
  - Works with mod_perl.
  - Preferences works.
  - Support for page metadata.
  - RecentChanges shows who last edited page.
  - Almost all non-perl content is now written to 
    appropriate files. Javascript, CSS etc. Much easier to
    maintain and extend now.
  - Support mailto links and inline code.
  - https links added. Thanks to GregSchueler.
  - ':' added to charset for page names. Suggested by 
    JamesFitzGibbon.
  - Javascript fix reported by MikeArms.
  - Security hole in CGI params fixed. Reported by 
    TimSweetman.
  - Emacs artifact bug fix by HeikkiLehvaslaiho.
  - Cleaned up unneeded <p> tags. Reported by HolgerSchurig
__KwikiBlog__
*Due next release or two*.

Certain Kwiki pages will be bloggable. This means they can also be protected from general update.
__KwikiFeatures__
The overall design goal of CGI::Kwiki is /simplicity/ and /extensibility/. 

Even so, Kwiki will have some killer builtin features not available in most wikis:

* KwikiSlideShow
* KwikiBlog
* KwikiSisters
* KwikiHotKeys
* KwikiFit
* KwikiPod

Each feature is implemented as a separate plugin class. This keeps things _simple_ and _extensible_.
__KwikiFit__
*Due next release or so*

CGI::Kwiki can be made to write Test::FIT test files directly into a Perl modules test harness. Eventually this will be a popular way of module testing in Perl. (Just you wait and see!)
__KwikiFormatterModule__
CGI::Kwiki::Formatter is the module that does all the formatting from Wiki text to html. It deserves good documentation. Forthcoming...
__KwikiFormattingRules__
This page describes the wiki markup language used by this kwiki.
----
^= Level 1 Heading (H1) =
  = Level 1 Heading (H1) =
----
^== Level 2 Heading (H2) ==
  == Level 2 Heading (H2) ==
----
^=== Level 3 Heading (H3) ===
  === Level 3 Heading (H3) ===
----
^==== Level 4 Heading (H4)
  ==== Level 4 Heading (H4)
----
^===== Level 5 Heading (H5)
  ===== Level 5 Heading (H5)
----
^====== Level 6 Heading (H6)
  ====== Level 6 Heading (H6)
----
The horizontal lines in this page are made with 4 or more dashes:
  ----
----
Paragraphs are separated by a blank line.

Like this. Another paragraph.
  Paragraphs are separated by a blank line.

  Like this. Another paragraph.
----
*Bold text*, /italic text/, and _underscore text_.
  *Bold text*, /italic text/, and _underscore text_.
/*Combination of bold and italics*/
  /*Combination of bold and italics*/
Inline code like [=/etc/passwd] or [=CGI::Kwiki]
  Inline code like [=/etc/passwd] or [=CGI::Kwiki]
----
WikiLinks are formed by two or more words in /camel-case/.
  WikiLinks are formed by two or more words in /camel-case/.
External links begin with http://, like http://www.freepan.org
  External links begin with http://, like http://www.freepan.org
Forced wiki [links] are a alphnumeric string surrounded by square brackets.
  Forced wiki [links] are a alphnumeric string surrounded by square brackets.
Named http links have text with an http:// link inside, like [FreePAN http://www.freepan.org Site]
  Named http links have text with an http:// link inside, like [FreePAN http://www.freepan.org Site]
Sometimes !WordsShouldNotMakeAWikiLink so put a '!' beforehand.
  Sometimes !WordsShouldNotMakeAWikiLink so put a '!' beforehand.
Same thing with !http://foobar.com
  Same thing with !http://foobar.com
Mailto links are just email addresses like foo@bar.com.
  Mailto links are just email addresses like foo@bar.com.
----
Links to images display the image:

http://www.google.com/images/logo.gif
  http://www.google.com/images/logo.gif
----
Unordered lists begin with a '* '. The number of asterisks determines the level:
* foo
* bar
** boom
** bam
* baz
  * foo
  * bar
  ** boom
  ** bam
  * baz
----
Ordered lists begin with a '0 ' (zero):
0 foo
0 bar
00 boom
00 bam
0 baz
  0 foo
  0 bar
  00 boom
  00 bam
  0 baz
----
You can mix lists too:
* Today:
00 Eat icecream
00 Buy a pony
* Tommorrow:
00 Eat more icecream
00 Buy another pony
  * Today:
  00 Eat icecream
  00 Buy a pony
  * Tommorrow:
  00 Eat more icecream
  00 Buy another pony
----
Any text that does not begin in the first column is rendered as preformatted text.
      foo   bar
       x     y
       1     2
----
You can comment out wiki-text with '# ' at the beginning of a line. This will make the text an html comment:
# These lines have been 
# commented out
  # These lines have been 
  # commented out
----
Simple Tables:
|        | Dick   | Jane |
| height | 72"    | 65"  |
| weight | 130lbs | 150lbs |
  |        | Dick   | Jane |
  | height | 72"    | 65"  |
  | weight | 130lbs | 150lbs |
----
Tables with multiline or complex data:
| <<END | <<END |
This data has vertical | bars |
END
# This is some Perl code:
sub foo {
    print "I want a kwiki!\n"
}
END
| foo | <<MSG |
As you can see we use
the Perl heredoc syntax.
MSG
  | <<END | <<END |
  This data has vertical | bars |
  END
  # This is some Perl code:
  sub foo {
      print "I want a kwiki!\n"
  }
  END
  | foo | <<MSG |
  As you can see we use
  the Perl heredoc syntax.
  MSG
__KwikiHelpIndex__
CGI::Kwiki is simple yet powerful Wiki environment written in Perl as a CPAN module distribribution. It was written by BrianIngerson.

^=== Kwiki Basics ===

* KwikiInstallation
* KwikiUpgrading
* KwikiFeatures
* KwikiFormattingRules
* KwikiNavigation

^=== CGI::Kwiki Development ===

* KwikiAbout
* KwikiTodo
* KwikiKnownBugs

^=== CGI::Kwiki Class/Module Documentation ===

* KwikiModule
* KwikiDriverModule
* KwikiConfigModule
* KwikiConfigYamlModule
* KwikiFormatterModule
* KwikiDatabaseModule
* KwikiMetadataModule
* KwikiDisplayModule
* KwikiEditModule
* KwikiTemplateModule
* KwikiCgiModule
* KwikiCookieModule
* KwikiSearchModule
* KwikiChangesModule
* KwikiPrefsModule
* KwikiNewModule
* KwikiPagesModule
* KwikiStyleModule
* KwikiScriptsModule
* KwikiJavascriptModule
* KwikiSlidesModule
__KwikiHotKeys__
*Coming Soon*

Kwiki defines a number of special keys you can press at any time for enhanced KwikiNavigation:

* t - Top Page
* r - RecentChanges
* spacebar - Next most recent page
* e - Edit
* s - Save
* p - Preview
* h - KwikiHelpIndex
* ? - KwikiHotKeys
* ! - A Random Kwiki Page
* $ - Donate to the Kwiki Project
__KwikiInstallation__
^== Installing a Kwiki Site ==

Kwiki is a snap to install.

First:
* Download and install the CGI::Kwiki module from [CPAN http://search.cpan.org/search?query=cgi-kwiki&mode=dist]
* Have an Apache web server.

Second:
* Make a new directory in your Apache cgi-bin.
* Go into this directory and run:

  kwiki-install

Third:
* Point your browser at the new location.
* Viola! You can set up new Kwikis in seconds.
----

^== Apache Config ==

Here's a sample Apache config section that may help.

  Alias /kwiki/ /home/ingy/kwiki/
  <Directory /home/ingy/kwiki/>
      Order allow,deny
      Allow from all
      AllowOverride None
      Options ExecCGI
      AddHandler cgi-script .cgi
  </Directory>

Adjust to your needs.

^== See Also: ==
* KwikiUpgrading
* KwikiModPerl
__KwikiKnownBugs__
See also: KwikiTodo

* No backup system yet
__KwikiLogoImage__
A logo image is something like a "coat of arms" for your kwiki. It is very useful for identifying your kwiki, especially from other wiki sites.

Kwiki formatting looks best when your image is 90x90 pixels. You should also have a second version of your image that renders nicely at 50x50 pixels. This will be used by KwikiSisters to link to your site.
__KwikiModPerl__
Apache's mod_perl makes Perl applications run much faster and scale well to heavy usage. Using Kwiki with mod_perl is a piece of cake. 

First you need is an Apache server built with mod_perl support. See http://perl.apache.org for more information.

Then install a Kwiki site following the normal KwikiInstallation procedures.

Finally add something like this to your Apache configuration:

  Alias /kwiki/ /home/ingy/kwiki/
  <Directory /home/ingy/kwiki/>
      Order allow,deny
      Allow from all
      AllowOverride None
      Options None
      SetHandler perl-script
      PerlHandler CGI::Kwiki
  </Directory>
  <Directory /home/ingy/kwiki/css/>
      Order allow,deny
      Allow from all
      AllowOverride None
      Options None
      SetHandler none
  </Directory>
  <Directory /home/ingy/kwiki/javascript/>
      Order allow,deny
      Allow from all
      AllowOverride None
      Options None
      SetHandler none
  </Directory>

That's it! You'll get an instant *performance boost*.

You can switch from the standard CGI installation to mod_perl anytime you want.
__KwikiNavigation__
* Use the RecentChanges link at the top of each page to find out which pages have been edited lately.
* The *Search* box let's you search the full text of kwiki pages for a given term.
* Use the KwikiHotKeys to move around the Kwiki easily.
__KwikiPod__
*Due soon*

The KwikiFormatterModule can be extended to create POD in addition to HTML. The will be nice for Perl Module authors. 

Theoretically, all the documentation and testing of Perl modules can be done inside a kwiki. BrianIngerson is starting to do this already.

Stay tuned.
__KwikiSisters__
*Due next release*.

Sister Sites is a way of providing accidental linking between your Kwiki and other wiki sites of your choosing.

See http://c2.com/cgi/wiki?AboutSisterSites for more info.
__KwikiSlideShow__
CGI::Kwiki has a !PowerPoint-like slideshow built in. Give it a try.

*Click Here to start the slideshow*:
[&SLIDESHOW_SELECTOR]
# title: Intro to Kwiki SlideShow
----
^== Welcome to the Kwiki Slide Show Example ==
* Press spacebar to go to next slide
* You can also click on the slide to advance
----
^== How it works ==
* You create all your slides as a single wiki page
* Slides are separated by horizontal lines
----
^== Controls ==
* Press spacebar to go to next slide
* Press backspace to go to previous slide
* Press '1' to start over
* Press 'q' to quit
----
^== Adjustments ==
* You should probably adjust your fonts
* Mozilla uses <ctl>+ and <ctl>-
* Very handy for adjusting on the fly
----
^== Bugs ==
* Everything works in Mozilla and IE
* Some browsers do not seem to respond well to the onkeypress events.
** Often you can get around this by using backspace or delete to go back a slide.
----
^== Displaying Source Code ==
* Here is some Javascript code:
    function changeSlide(i) {
        var myForm = document.getElementsByTagName("form")[0];
        var myNum = myForm.getElementsByTagName("input")[0];
        i = i * 1;
        myVal = myNum.value * 1;
        myNum.value = myVal + i;
        myForm.submit();
    }
* Here is some Perl code:
    sub process {
        my ($self) = @_;
        return $self->cgi->size ? $self->open_window 
                                : $self->slide;
    }
----
^== The End ==
__KwikiTodo__
See also: KwikiKnownBugs

Address:
* Strategy for handling edit collisions
* RCS revision control
* Public/Protected/Private security with basic authentication

Add these features:

* KwikiSisters
* KwikiBlog
* KwikiFit
* KwikiPod
__KwikiUpgrading__
^== Upgrading a Kwiki Site ==

After installing the new CGI::Kwiki module, just cd into the old Kwiki directory and reinstall with:

  kwiki-install --upgrade

This will upgrade everything except the config file and the changed pages. Other upgrade options are:

  --reinstall  - Upgrade everything including config file.
  --config     - Upgrade config file. You will lose local settings!
  --scripts    - Upgrade cgi scripts.
  --pages      - Upgrade default kwiki pages unless changed by a user.
  --template   - Upgrade templates.
  --javascript - Upgrade javascript.
  --style      - Upgrade css stylesheets.
__KwikiUserName__
You should strongly consider entering a username in [Preferences http:index.cgi?action=prefs]. This will allow the kwiki to keep track of who changed what page. The username will show up in the RecentChanges page.

The username is saved in a cookie, so it should stay around after you are done with your session. If you happen to be using a public machine, you may wish to clear the username when you are done.

By default Kwiki requires that you create a page about yourself prior to setting your username. So if your name is Eddy Merckz, you should create a page called EddyMerckz, and describe yourself a bit. Then you can go to [Preferences http:index.cgi?action=prefs], and set your username.
