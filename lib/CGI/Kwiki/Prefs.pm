package CGI::Kwiki::Prefs;
$VERSION = '0.14';
use strict;
use base 'CGI::Kwiki';
use CGI::Kwiki;

attribute 'user_name';
attribute 'error_msg';

sub process {
    my ($self) = @_;
    $self->user_name($self->driver->cookie->prefs->{user_name} || '');
    $self->error_msg('');
    $self->save 
      if $self->cgi->button eq 'SAVE';
    $self->cgi->page_id('Preferences');
    return
      $self->template->process('display_header',
          $self->template->display_vars,
      ) .
      $self->template->process('prefs_body',
          error_msg => $self->error_msg,
          user_name => $self->user_name,
      ) .
      $self->template->process('display_footer');
}

sub save {
    my ($self) = @_;
    my $user_name = $self->cgi->user_name;
    $self->user_name($user_name);
    unless ($user_name eq '' or $self->driver->database->exists($user_name)) {
        $self->error_msg(
          '<p>Username must be a valid wiki page (about yourself).</p>');
        return;
    }
    $self->driver->cookie->prefs({user_name => $user_name});
}
    
1;

__END__

=head1 NAME 

CGI::Kwiki::Prefs - Preferences Base Class for CGI::Kwiki

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
