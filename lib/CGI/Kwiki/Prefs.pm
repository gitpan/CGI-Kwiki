package CGI::Kwiki::Prefs;
$VERSION = '0.01';
use strict;
use base 'CGI::Kwiki';
use CGI::Kwiki;

attribute 'user_name';
attribute 'error_msg';

sub process {
    my ($self) = @_;
    $self->error_msg('');
    $self->save 
      if $self->cgi->button =~ /^save$/i;
    $self->cgi->page_id('Preferences');
    return
      $self->template->header .
      $self->body .
      $self->template->footer;
}

sub save {
    my ($self) = @_;
    my $user_name = $self->cgi->user_name;
    unless ($user_name and $self->driver->database->exists($user_name)) {
        $self->error_msg('<font color="red">User name must have a valid wiki page</font>');
        return;
    }
    $self->driver->cookie->prefs({user_name => $user_name});
}
    
sub body {
    my ($self) = @_;
    my $user_name = $self->driver->cookie->prefs->{user_name};
    my $error_msg = $self->error_msg;
<<END;
$error_msg
<form>
<br>
UserName: &nbsp;
<input type="text" name="user_name" value="$user_name" size="20" /> 
<br><br>
<input type="submit" name="button" value="SAVE" />
<input type="hidden" name="action" value="prefs" />
</form>
END
}

1;

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
