package CGI::Kwiki::CGI;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';

sub all {
    my ($self) = @_;
    return (
        CGI::Vars(), 
        page_id => $self->page_id,
    );
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

sub action {
    my ($self) = shift(@_);
    if (@_) {
        $self->{action} = shift(@_);
        return $self;
    }
    my $action = CGI::param('action') || '';
    $action = '' if $action =~ /[^\w]/;
    return $action || 'display';
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
    $query_string =~ s/%3a/:/gi;
    if ($query_string =~ /^keywords=([\w\-:]+)$/) {
        $page_id = $1;
    }
    else {
        $page_id = CGI::param('page_id') || 
                   $self->config->top_page;
    }
    $page_id = '' if $page_id =~ /[^\w\-\:]/;
    return $page_id || $self->config->top_page;
    return $page_id;
}

use vars qw($AUTOLOAD);
sub AUTOLOAD {
    my $param = $AUTOLOAD;
    $param =~ s/.*://;
    my ($self) = shift(@_);
    if (@_) {
        $self->{$param} = shift(@_);
        return $self;
    }
    my $value = CGI::param($param) || '';
    $value =~ s/[^\w\-\:\.\,\|]//g;
    return $value;
}

1;

__END__

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
