package CGI::Kwiki::Pages;
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


__HomePage__
This is the *default* home page. You should change this page /right away/.
Click the edit button.
----
If you need help first, check out:

* KwikiHelpIndex


__KwikiHelpIndex__
=== Kwiki Basics ===

* KwikiFormattingRules
* KwikiInstallation

=== CGI::Kwiki Class Documentation ===

* KwikiFormatterClass

=== CGI::Kwiki Development ===

* KwikiTodo
* KwikiKnownBugs


__KwikiTodo__
See also: KwikiKnownBugs

* Support preferences:
** User name
** Edit buttons on top or bottom
* Strategy for handling edit collisions
* RCS revision control

__KwikiKnownBugs__
See also: KwikiTodo

* Preferences does not work yet
* No backup system yet
* Search requires unix 'grep' command


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
WikiLinks are formed my two or more words in /camel-case/.
  WikiLinks are formed my two or more words in /camel-case/.
External links begin with htpp://, like http://www.freepan.org
  External links begin with htpp://, like http://www.freepan.org
Forced wiki [links] are a alphnumeric string surrounded by square brackets.
  Forced wiki [links] are a alphnumeric string surrounded by square brackets.
Named http links have text with an http:// link inside, like [FreePAN http://www.freepan.org Site]
  Named http links have text with an http:// link inside, like [FreePAN http://www.freepan.org Site]
Sometimes !WordsShouldNotMakeAWikiLink so put a '!' beforehand.
  Sometimes !WordsShouldNotMakeAWikiLink so put a '!' beforehand.
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


