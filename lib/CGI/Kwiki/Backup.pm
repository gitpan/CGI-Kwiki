package CGI::Kwiki::Backup;
$VERSION = '0.17';
use strict;

use base 'CGI::Kwiki';

sub commit {
    1;
}

sub has_history {
    0;
}

1;
