package CGI::Kwiki;
$VERSION = '0.11';
@EXPORT = qw(attribute);
use strict;
use base 'Exporter';
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

sub attribute {
    my ($attribute) = @_;
    my $pkg = caller;
    no strict 'refs';
    *{"${pkg}::$attribute"} =
      sub {
          my $self = shift;
          return $self->{$attribute} unless @_;
          $self->{$attribute} = shift;
          return $self;
      };
}

sub run_cgi {
    require CGI::Kwiki::Config;
    my $config = CGI::Kwiki::Config->new;
    my $driver_class = $config->driver_class
      or die "driver_class not defined in configuration";
    eval qq{ require $driver_class }; die $@ if $@;
    my $driver = $driver_class->new($config);
    my $html = $driver->drive;
    require CGI;
    if (ref $html) {
        print CGI::redirect($html->{redirect});
    }
    else {
        print $driver->cookie->header, $html;
    }
}

1;

__END__

=head1 NAME

CGI::Kwiki - A Quickie Wiki that's not too Tricky

=head1 SYNOPSIS

    > mkdir cgi-bin/my-kwiki
    > cd cgi-bin/my-kwiki
    > kwiki-install

    Kwiki software installed! Point your browser at this location.

=head1 DESCRIPTION

A Wiki is a website that allows its users to add pages, and edit any
existing pages. It is one of the most popular forms of web
collaboration. If you are new to wiki, visit
http://c2.com/cgi/wiki?WelcomeVisitors which is possibly the oldest
wiki, and has lots of information about how wikis work.

There are dozens of wiki implementations in the world, and many of those
are written in Perl. As is common with many Perl hacks, they are rarely
modular, and almost never released on CPAN. One major exception is
CGI::Wiki. This is a wiki framework that is extensible and is actively
maintained.

Another exception is this module, CGI::Kwiki. CGI::Kwiki focuses on
simplicity and extensibility. You can create a new kwiki website with a
single command. The module has no prerequisite modules, except the
ones that ship with Perl. It doesn't require a database backend,
although it could be made to use one. The default kwiki behaviour is
fairly full featured, and includes support for html tables. Any
behaviour of the kwiki can be customized, without much trouble.

=head1 EXTENDING

CGI::Kwiki is completely Object Oriented. You can easily override every
last behaviour by subclassing one of its class modules and overriding
one or more methods. This is generally accomplished in just a few
lines of Perl.

The best way to describe this is with an example. Start with the config
file. The default config file is called C<config.yaml>. It contains a
set of lines like this:

    config_class:    CGI::Kwiki::Config
    driver_class:    CGI::Kwiki::Driver
    cgi_class:       CGI::Kwiki::CGI
    database_class:  CGI::Kwiki::Database
    display_class:   CGI::Kwiki::Display
    edit_class:      CGI::Kwiki::Edit
    formatter_class: CGI::Kwiki::Formatter
    template_class:  CGI::Kwiki::Template
    search_class:    CGI::Kwiki::Search
    prefs_class:     CGI::Kwiki::Prefs

This is a list of all the classes that make up the kwiki. You can change
anyone of them to be a class of your own.

Let's say that you wanted to change the B<BOLD> format indicator from
C<*bold*> to C<'''bold'''>. You just need to override the C<bold()>
method of the Formatter class. Start by changing C<config.yaml>.

    formatter_class: MyKwikiFormatter

Then write a module called C<MyKwikiFormatter.pm>. You can put this
module right in your kwiki installation directory if you want. The
module might look like this:

    package MyKwikiFormatter;
    use base 'CGI::Kwiki::Formatter';

    sub bold {
        my ($self, $text) = @_;
        $text =~ s!'''(.*?)'''!<b>$1</b>!g;
        return $text;
    }

    1;

Not too hard, eh? You can change all aspects of CGI::Kwiki like this,
from the database storage to the search engine, to the main driver code.
If you come up with a set of classes that you want to share with the
world, just package them up as a distribution and put them on CPAN.

By the way, you can even change the configuration file format from the
YAML default. If you wanted to use say, XML, just call the file
C<config.xml> and write a module called C<CGI::Kwiki::ConfigParse_xml>.

=head1 SEE ALSO

All of the rest of the documentation for CGI::Kwiki is available within
your own kwiki installation. Just install a kwiki and follow the links!

=head1 AUTHOR

Brian Ingerson <INGY@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2003. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
