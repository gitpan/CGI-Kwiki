package CGI::Kwiki::Config;
$VERSION = '0.10';
use strict;
use CGI::Kwiki;

attribute 'new_class';
attribute 'config_class';
attribute 'driver_class';
attribute 'cgi_class';
attribute 'database_class';
attribute 'display_class';
attribute 'edit_class';
attribute 'formatter_class';
attribute 'template_class';
attribute 'search_class';
attribute 'changes_class';
attribute 'prefs_class';
attribute 'pages_class';

attribute 'top_page';
attribute 'kwiki_image';
attribute 'title_prefix';

sub new {
    my ($class) = @_;
    my ($config_file, @error) = glob "config.*";
    die "No config file found"
      unless defined $config_file;
    die "More than one config file found"
      if @error;
    die "Invalid config file name '$config_file'"
      unless $config_file =~ /config\.(\w+)/;
    my $extension = lc($1);
    my $parse_class = "CGI::Kwiki::ConfigParse_$extension";
    eval qq{ require $parse_class }; die $@ if $@;
    my $parser = $parse_class->new;
    my $hash = $parser->parse_file($config_file);
    my $config_class = $hash->{config_class}
      or die "config_class not defined in $config_file\n";
    eval qq{ require $config_class }; die $@ if $@;
    my $self = bless $parser->parse_file($config_file), $config_class;
    return $self;
}

1;

=head1 NAME 

CGI::Kwiki::Config - Config Base Class for CGI::Kwiki

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
