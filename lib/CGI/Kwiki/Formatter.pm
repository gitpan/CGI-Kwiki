package CGI::Kwiki::Formatter;
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

sub process_order {
    return qw(
        function
        table code header_1 header_2 header_3 
        escape_html
        lists comment horizontal_line
        paragraph 
        named_http_link no_http_link http_link
        no_wiki_link wiki_link force_wiki_link
        bold italic underscore
    );
}

sub process {
    my ($self, $wiki_text) = @_;
    my $array = [];
    push @$array, $wiki_text;
    for my $method ($self->process_order) {
        $array = $self->dispatch($array, $method);
    }
    return $self->combine_chunks($array);
}

sub dispatch {
    my ($self, $old_array, $method) = @_;
    return $old_array unless $self->can($method);
    my $new_array;
    for my $chunk (@$old_array) {
        if (ref $chunk eq 'ARRAY') {
            push @$new_array, $self->dispatch($chunk, $method);
        }
        else {
            if (ref $chunk) {
                push @$new_array, $chunk;
            }
            else {
                push @$new_array, $self->$method($chunk);
            }
        }
    }
    return $new_array;
}

sub function {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        my @return = ($_);
        if ($switch++ % 2) {
            s#%%(.*?)%%#$1#;
            my ($method, @args) = split;
            @return = ();
            if ($self->can($method)) {
                @return = $self->$method(@args);
            }
        }
        @return
    }
    split m#(^%%[A-Z_]+\b.*?%%$)#m, $text;
}

sub TRANSCLUDE_HTTP_BODY {
    my ($self, $url) = @_;
    require LWP::Simple;
    my $html = LWP::Simple::get($url)
      or return '';
    $html =~ s#.*<body>(.*)</body>.*#$1#is;
    \ $html;
}

sub table {
    my ($self, $text) = @_;
    my @array;
    while ($text =~ /(.*?)(^\|[^\n]*\|\n.*)/ms) {
        push @array, $1;
        my $table;
        ($table, $text) = $self->parse_table($2);
        push @array, $table;
    }
    push @array, $text if length $text;
    return @array;
}

sub parse_table {
    my ($self, $text) = @_;
    my $error = '';
    my $rows;
    while ($text =~ s/^(\|(.*)\|\n)//) {
        $error .= $1;
        my $data = $2;
        my $row = [];
        for my $datum (split /\|/, $data) {
            $datum =~ s/^\s*(.*?)\s*$/$1/;
            if ($datum =~ s/^<<(\S+)$//) {
                my $marker = $1;
                while ($text =~ s/^(.*\n)//) {
                    my $line = $1;
                    $error .= $line;
                    if ($line eq "$marker\n") {
                        $marker = '';
                        last;
                    }
                    $datum .= $line;
                }
                if (length $marker) {
                    return ($error, $text);
                }
            }
            push @$row, $datum;
        }
        push @$rows, $row;
    }
    return ($self->format_table($rows), $text);
}

sub format_table {
    my ($self, $rows) = @_;
    my $cols = 0;
    for (@$rows) {
        $cols = @$_ if @$_ > $cols;
    }
    my $table = qq{<blockquote>\n<table border="1">\n};
    for my $row (@$rows) {
        $table .= qq{<tr valign="top">\n};
        for (my $i = 0; $i < @$row; $i++) {
            my $colspan = '';
            if ($i == $#{$row} and $cols - $i > 1) {
                $colspan = ' colspan="' . ($cols - $i) . '"';
            }
            my $cell = $self->escape_html($row->[$i]);
            $cell = qq{<pre>$cell</pre>\n}
              if $cell =~ /\n/;
            $cell = '&nbsp;' unless length $cell;
            $table .= qq{<td$colspan>$cell</td>\n};
        }
        $table .= qq{</tr>\n};
    }
    $table .= qq{</table></blockquote>\n};
    return \$table;
}

sub no_wiki_link {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            s#!##;
            $_ = \ do {my $x = $_};
        }
        $_;
    }
    split m#(![A-Z][a-z]+[A-Z]\w+)#, $text;
}

sub wiki_link {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            $_ = qq{<a href="?$_">$_</a>};
            $_ = \ do {my $x = $_};
        }
        $_;
    }
    split m!([A-Z][a-z]+[A-Z]\w+)!, $text;
}

sub force_wiki_link {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            $_ = qq{<a href="?$_">$_</a>};
            $_ = \ do {my $x = $_};
        }
        $_;
    }
    split m!\[([\w-]+)\]!, $text;
}

sub no_http_link {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            s#!##;
            $_ = \ do {my $x = $_};
        }
        $_;
    }
    split m#(!http://\S+?(?=[),.:;]?\s|$))#m, $text;
}

sub http_link {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            if (/\.(jpg|gif|jpeg|png)/) {
                $_ = qq{<img src="$_">};
            }
            else {
                $_ = qq{<a href="$_">$_</a>};
            }
            $_ = \ do {my $x = $_};
        }
        $_;
    }
    split m!(http://\S+?(?=[),.:;]?\s|$))!m, $text;
}

sub named_http_link {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            my $link = '';
            $link = $2 if s#^\[(.*)(http://\S+)(.*)\]$#$1$3#;
            $link = $2 if s#^\[(.*)http:(\S+)(.*)\]$#$1$3#;
            s#\s*(.*?)\s*#$1#;
            $_ = qq{<a href="$link">$_</a>};
            $_ = \ do {my $x = $_};
        }
        $_;
    }
    split m!(\[.*?http:\S.*?\])!, $text;
}

sub bold {
    my ($self, $text) = @_;
    $text =~ s#(?<!\w)\*([\w<].*?[>\w])\*(?!\w)#<b>$1</b>#g;
    return $text;
}

sub italic {
    my ($self, $text) = @_;
    $text =~ s#(?<![\w<])/([\w<].*?[>\w])/(?!\w)#<em>$1</em>#g;
    return $text;
}

sub underscore {
    my ($self, $text) = @_;
    $text =~ s#(?<!\w)_([\w<].*?[>\w])_(?!\w)#<u>$1</u>#g;
    return $text;
}

sub code {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            $_ = $self->preformat($_);
            $_ = \ do {my $x = $_};
        }
        $_;
    }
    split m!(^ +[^ \n].*?\n)(?=[^ \n]|$)!ms, $text;
}

sub lists {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        my $level = 0;
        my @tag_stack;
        if ($switch++ % 2) {
            my $text = '';
            my @lines = /(.*\n)/g;
            for my $line (@lines) {
                $line =~ s/^([0\*]+) //;
                my $new_level = length($1);
                my $tag = ($1 =~ /0/) ? 'ol' : 'ul';
                if ($new_level > $level) {
                    for (1..($new_level - $level)) {
                        push @tag_stack, $tag;
                        $text .= "<$tag>\n";
                    }
                    $level = $new_level;
                }
                elsif ($new_level < $level) {
                    for (1..($level - $new_level)) {
                        $tag = pop @tag_stack;
                        $text .= "</$tag>\n";
                    }
                    $level = $new_level;
                }
                $text .= "<li>$line";
            }
            for (1..$level) {
                my $tag = pop @tag_stack;
                $text .= "</$tag>\n";
            }
            $_ = $text;
        }
        $_;
    }
    split m!(^[0\*]+ .*?\n)(?=(?:[^0\*]|$))!ms, $text;
}

sub paragraph {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        unless ($switch++ % 2) {
            $_ = "<p>\n$_\n</p>\n";
        }
        $_;
    }
    split m!(\n\s*\n)!ms, $text;
}

sub preformat {
    my ($self, $text) = @_;
    my @indents = $text =~ /^( +)[^ \n]/gm;
    my $indent = 10000;
    for (@indents) {
        $indent = length($_) if length($_) < $indent;
    }
    $text =~ s/^ {$indent}//gm;
    $text = $self->escape_html($text);
    return "<blockquote><pre>$text</pre></blockquote>\n";
}

sub escape_html {
    my ($self, $text) = @_;
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text;
}

sub horizontal_line {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            s!----+!<hr>!;
            $_ = \ do {my $x = $_};
        }
        $_;
    }    
    split m!(^----+\n)!m, $text;
}

sub comment {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            s/\# (.*)/<!-- $1 -->/;
            $_ = \ do {my $x = $_};
        }
        $_;
    }    
    split m!(^\# .*\n)!m, $text;
}

sub header_1 {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            s!= (.*) =!<h1>$1</h1>!;
            $_ = \ do {my $x = $_};
        }
        $_;
    }    
    split m!(^= (?:.*) =\n)!m, $text;
}

sub header_2 {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            s!== (.*) ==!<h2>$1</h2>!;
            $_ = \ do {my $x = $_};
        }
        $_;
    }    
    split m!(^== (?:.*) ==\n)!m, $text;
}

sub header_3 {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            s!=== (.*) ===!<h3>$1</h3>!;
            $_ = \ do {my $x = $_};
        }
        $_;
    }    
    split m!(^=== (?:.*) ===\n)!m, $text;
}

sub combine_chunks {
    my ($self, $chunk_array) = @_;
    my $formatted_text = '';
    for my $chunk (@$chunk_array) {
        $formatted_text .= 
          (ref $chunk eq 'ARRAY') ? $self->combine_chunks($chunk) :
          (ref $chunk) ? $$chunk :
          $chunk
    }
    return $formatted_text;
}

1;

=head1 NAME 

CGI::Kwiki::Formatter - Formatter Base Class for CGI::Kwiki

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
