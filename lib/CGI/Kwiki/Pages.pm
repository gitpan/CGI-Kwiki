package CGI::Kwiki::Pages;
$VERSION = '0.12';
use strict;
use base 'CGI::Kwiki';

sub default_pages {
    my ($self) = @_;
    my @pages = split /^__(\w+)__/m, join '', <DATA>;
    shift @pages;
    my %pages = @pages;
    $self->driver->load_class('database');
    $self->driver->database->store_new('HomePage', $pages{HomePage});
    delete $pages{HomePage};
    for my $page_id (keys %pages) {
        $self->driver->database->store($page_id, $pages{$page_id});
    }
}
    
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

__AgileProgrammingLanguages__
"Agile" is the latest term for classifying what are commonly referred to as "Scripting" languages. This includes (minimally):

* Perl
* Python
* PHP
* Ruby
__BrianIngerson__
Brian "ingy" Ingerson is a Perl devotee and [CPAN http://search.cpan.org/author/INGY/] module author. His modules include CGI::Kwiki which is the Wiki software you are presently using.

He has a dream to see the communities of all the AgileProgrammingLanguages working together. He is attemping to facilitate this in many ways including:

* [YAML http://www.yaml.org]
* [FreePAN http://www.freepan.org]
* [FIT http://fit.freepan.org]
* [Moss http://moss.freepan.org]
__HomePage__
*Congratulations*! You've created a new _Kwiki_ website.

This is the *default* home page. You should change this page /right away/.

Just click the edit button below.

You may also want to add a logo image in the config.yaml file. It will appear in the upper lefthand corner.
----
If you need help using wiki first, check out:

* KwikiHelpIndex
* KwikiFeatures
__KwikiBlog__
*Due next release or two*.

Certain Kwiki pages will be bloggable. This means they can also be protected from general update.
__KwikiFeatures__
The overall design goal of CGI::Kwiki is /simplicity/ and /extensibility/. 

Even so, Kwiki will have some killer builtin features not available in most wikis:

* KwikiSlideShow
* KwikiBlog
* KwikiSisters
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
= Level 1 Heading (H1) =
  = Level 1 Heading (H1) =
----
== Level 2 Heading (H2) ==
  == Level 2 Heading (H2) ==
----
=== Level 3 Heading (H3) ===
  === Level 3 Heading (H3) ===
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

=== Kwiki Basics ===

* KwikiFormattingRules
* KwikiInstallation
* KwikiFeatures

=== CGI::Kwiki Class/Module Documentation ===

* KwikiFormatterModule

=== CGI::Kwiki Development ===

* KwikiTodo
* KwikiKnownBugs

*NOTE*: It is wise not to make local modifications of pages that begin with "Kwiki" as these pages will be replaced when you upgrade the CGI::Kwiki software.
__KwikiInstallation__
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

== Upgrading a Kwiki Site ==
After installing the new CGI::Kwiki module, just cd into the old Kwiki directory and type:
  kwiki-install

----

== Apache Config ==

Here's a sample Apache config section that may help.

  Alias /kwiki/ /home/ingy/kwiki/
  <Directory /home/ingy/kwiki/>
      Order allow,deny
      Allow from all
      AllowOverride None
      Options ExecCGI FollowSymLinks Indexes
      AddHandler cgi-script .cgi
  </Directory>

Adjust to your needs.
__KwikiKnownBugs__

See also: KwikiTodo

* Preferences does not work yet
* No backup system yet
* Search requires unix 'grep' command


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
CGI::Kwiki has a Power Point like slideshow built in. Give it a try.

*Click Here to start the slideshow*:
%%SLIDESHOW_SELECTOR%%
# title: Intro to Kwiki SlideShow
----
== Welcome to the Kwiki Slide Show Example ==
* Press spacebar to go to next slide
* You can also click on the slide to advance
----
== How it works ==
* You create all your slides as a single wiki page
* Slides are separated by horizontal lines
----
== Controls ==
* Press spacebar to go to next slide
* Press backspace to go to previous slide
* Press '1' to start over
* Press 'q' to quit
----
== Adjustments ==
* You should probably adjust your fonts
* Mozilla uses <ctl>+ and <ctl>-
* Very handy for adjusting on the fly
----
== Bugs ==
* Everything works in Mozilla
* Other browsers do not seem to respond well to the onkeypress events.
----
== Source Code ==
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
== The End ==
__KwikiTodo__
See also: KwikiKnownBugs

* Support preferences:
** User name
** Edit buttons on top or bottom
* Strategy for handling edit collisions
* RCS revision control

And these features:

* KwikiSisters
* KwikiBlog
* KwikiFit
* KwikiPod
