package CGI::Kwiki::CGI;
$VERSION = '0.11';
use strict;
use CGI::Kwiki;

attribute 'driver';

sub new {
    require CGI;
    my ($class, $driver) = @_;
    my $self = bless {}, $class;
    $self->driver($driver);
    return $self;
}

sub button {
    my ($self) = shift(@_);
    $self->{button} = CGI::param('button')
      unless defined $self->{button};
    return $self->{button} || '' 
}

sub wiki_text {
    my ($self) = shift(@_);
    if (not defined $self->{wiki_text}) {
        $self->{wiki_text} = CGI::param('wiki_text');
        $self->{wiki_text} =~ s/\015\012/\n/g;
        $self->{wiki_text} =~ s/\015/\n/g;
        $self->{wiki_text} =~ s/\n*\z/\n/;
        $self->{wiki_text} = '' if $self->{wiki_text} eq "\n";
    }
    return $self->{wiki_text} 
}

sub search {
    my ($self) = shift(@_);
    $self->{search} = CGI::param('search')
      unless defined $self->{search};
    return $self->{search} 
}

sub action {
    my ($self) = shift(@_);
    if (@_) {
        $self->{action} = shift(@_);
        return $self;
    }
    return CGI::param('action') || 'display';
}

sub page_id {
    my ($self) = shift(@_);
    if (@_) {
        $self->{page_id} = shift(@_);
        return $self;
    }
    return $self->{page_id} 
      if defined $self->{page_id};
    my $page_id;
    my $query_string = CGI::query_string();
    if ($query_string =~ /^keywords=(\w+)$/) {
        $page_id = $1;
    }
    else {
        $page_id = CGI::param('page_id') || 
                   $self->driver->config->top_page;
    }
    return $page_id;
}

1;

=head1 NAME 

CGI::Kwiki::CGI - CGI Base Class for CGI::Kwiki

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
