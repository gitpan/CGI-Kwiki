package CGI::Kwiki::Driver;
$VERSION = '0.11';
use strict;
use CGI::Kwiki;
use CGI;


attribute 'config';
attribute 'database';
attribute 'cgi';
attribute 'cookie';
attribute 'formatter';
attribute 'template';
attribute 'display';
attribute 'edit';
attribute 'search';
attribute 'changes';
attribute 'prefs';
attribute 'preview';
attribute 'pages';

sub new {
    my ($class, $config) = @_;
    my $self = bless {}, $class;
    $self->config($config);
    $self->load_class('database');
    $self->load_class('cgi');
    $self->load_class('cookie');
    $self->load_class('template');
    return $self;
}

sub drive {
    my ($self) = @_;
    my $action = $self->cgi->action;
    $self->load_class($action);
    return $self->$action->process;
}

sub load_class {
    my ($self, $class) = @_;
    my $class_class = $class . '_class';
    my $class_name = $self->config->$class_class;
    eval qq{ require $class_name }; die $@ if $@;
    $self->$class($class_name->new($self));
}

1;

=head1 NAME 

CGI::Kwiki::Driver - Driver Base Class for CGI::Kwiki

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
