package CGI::Kwiki::Scripts;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;
    return $self;
}

sub directory { '.' }
sub suffix { '.cgi' }
sub render_template {
    my ($self, $template) = @_;
    return $self->render($template,
        start_perl => $Config::Config{startperl},
    );
}
sub perms {
    my ($self, $file) = @_;
    umask 0000;
    chmod(0755, $file) or die $!;
}

1;

__DATA__

=head1 NAME 

CGI::Kwiki::Config_yaml - Script container for CGI::Kwiki

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

__index__
[% start_perl %] -w
use lib '.';
use CGI::Kwiki;
CGI::Kwiki::run_cgi();
