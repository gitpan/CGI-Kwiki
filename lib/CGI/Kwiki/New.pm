package CGI::Kwiki::New;
$VERSION = '0.14';
use strict;
use Config;
use File::Path;
use CGI::Kwiki();

sub new {
    my ($class, $subclass) = @_;
    my $self;
    if (defined $subclass) {
        my $full_subclass = "CGI::Kwiki::New::$subclass";
        eval qq{ require $full_subclass }; die $@ if $@;
        $self = $full_subclass->new;
    }
    else {
        $self = bless {}, $class;
    }
    return $self;
}

sub create_kwiki {
    my ($self) = @_;
    $self->mkdirs;
    my $driver = CGI::Kwiki::load_driver();
    $CGI::Kwiki::user_name = 'kwiki-install';
    for my $class ($self->data_classes) {
        $driver->load_class($class);
        $driver->$class->create_files;
    }
    print "Kwiki software installed! Point your browser at this location.\n";
}

sub mkdirs {
    my ($self) = @_;
    for my $dir ($self->dirs) {
        unless (-d $dir) {
            umask 0000;
            mkdir($dir, 0777);
        }
    }
}

sub dirs {
    qw(metabase metabase/metadata);
}

sub data_classes {
    qw(scripts config_yaml pages template javascript style);
}

1;

__END__

=head1 NAME 

CGI::Kwiki::New - Default New Wiki Generator for CGI::Kwiki

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
