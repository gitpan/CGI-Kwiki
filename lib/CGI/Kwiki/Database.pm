package CGI::Kwiki::Database;
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

sub exists {
    my ($self, $page_id) = @_;
    $page_id ||= $self->driver->cgi->page_id;
    return -f "database/$page_id";
}

sub load {
    my ($self, $page_id) = @_;
    $page_id ||= $self->driver->cgi->page_id;
    my $file_path = "database/$page_id";
    if (-f $file_path) {
        local($/, *WIKIPAGE);
        open WIKIPAGE, $file_path or die $!;
        return <WIKIPAGE>;
    }
    else {
        return "Describe the new page here.\n";
    }
}

sub store {
    my ($self, $page_id, $wiki_text) = @_;
    $page_id ||= $self->driver->cgi->page_id;
    $wiki_text ||= $self->driver->cgi->wiki_text;
    my $file_path = "database/$page_id";
    open WIKIPAGE, '>', $file_path or die $!;
    print WIKIPAGE $wiki_text;
    close WIKIPAGE;
}

sub store_new {
    my ($self, $page_id) = @_;
    $page_id ||= $self->driver->cgi->page_id;
    return 0 if -f "database/$page_id";
    $self = shift;
    $self->store(@_);
}

1;

=head1 NAME 

CGI::Kwiki::Database - Database Base Class for CGI::Kwiki

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
