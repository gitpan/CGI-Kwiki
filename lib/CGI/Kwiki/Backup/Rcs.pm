package CGI::Kwiki::Backup::Rcs;
$VERSION = '0.17';
use strict;
use base 'CGI::Kwiki::Backup';

use constant RCS_DIR => 'metabase/rcs';

my $user_name = '';
sub new {
    my ($class) = shift;
    my $self = $class->SUPER::new(@_);
    unless (-d RCS_DIR) {
        mkdir RCS_DIR;
        $user_name = 'kwiki-install';
        for my $page_id ($self->driver->database->pages) {
            $self->commit($page_id);
        }
    }
    return $self;
}
    
sub commit {
    my ($self, $page_id) = @_;
    my $rcs_file_path = RCS_DIR . '/' . $page_id . ',v';
    if (not -f $rcs_file_path) {
        $self->shell("rcs -q -i $rcs_file_path < /dev/null");
    }
    my $msg = $user_name || $self->driver->metadata->edit_by;
    $self->shell(qq{ci -q -l -m"$msg" database/$page_id $rcs_file_path});
}

sub has_history {
    my ($self, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
    -f RCS_DIR . '/' . $page_id . ',v';
}

sub history {
    my ($self, $page_id) = @_;
    $page_id ||= $self->cgi->page_id;
    my $rcs_file_path = RCS_DIR . '/' . $page_id . ',v';
    open RLOG, "rlog -zLT $rcs_file_path |"
      or DIE $!; 
    local $/;
    my $input = <RLOG>;
    close RLOG;
    (my $rlog = $input) =~ s/\n=+$.*\Z//ms;
    my @rlog = split /^-+\n/m, $rlog;
    shift(@rlog);
    my $history = [];
    for (@rlog) {
        /^revision\s+(\S+).*?
         ^date:\s+(.+?);.*?\n
         (.*)
        /xms or die "Couldn't parse rlog for '$page_id':\n$rlog";
        push @$history,
          {
            revision => $1,
            date => $2,
            edit_by => $3,
          };
    }
    return $history;
}

sub fetch {
    my ($self, $page_id, $revision) = @_;
    my $rcs_file_path = RCS_DIR . '/' . $page_id . ',v';
    open CO, qq{co -q -p$revision $rcs_file_path |}
      or die $!;
    my $text = do {local $/; <CO>};
    close CO;
    return $text;
}

sub shell {
    my ($self, $command) = @_;
    system($command) == 0 
      or die "$command failed";
}

1;
