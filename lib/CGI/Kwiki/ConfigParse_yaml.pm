package CGI::Kwiki::ConfigParse_yaml;
$VERSION = '0.12';
use strict;

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;
    return $self;
}

sub parse_file {
    my ($self, $file) = @_;
    local(*CONFIG, $/);
    open CONFIG, $file
      or die "Can't open $file for input:\n$!";
    return $self->parse(<CONFIG>);
}

sub parse {
    my ($self, $yaml) = @_;
    my $hash = {};
    for (split /\n/, $yaml) {
        next if /\s*#/;
        next unless /: /;
        next unless /^\S/;
        next unless /(.*?)\s*:\s+(.*?)\s*$/;
        $hash->{$1} = $2;
    }
    return $hash;
}

1;

=head1 NAME 

CGI::Kwiki::ConfigParse_yaml - Simplistic YAML Config Parser for CGI::Kwiki

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
