package CGI::Kwiki::Formatter;
$VERSION = '0.13';
use strict;
use base 'CGI::Kwiki';
use CGI();

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

sub split_method {
    my ($self, $text, $regexp, $method, $mutable) = @_;
    $mutable ||= 0;
    my $switch = 0;
    return map {
        if ($switch++ % 2) {
            my $result = $self->$method($_);
            $_ = $mutable ? $result : \ $result;
        }
        $_;
    }
    split $regexp, $text;
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

sub SLIDESHOW_SELECTOR {
    my ($self) = @_;
    my $page_id = $self->cgi->page_id;
    my $html = <<END;
<script>
function startSlides() {
    var myForm = document.getElementsByTagName("form")[1];
    var mySize = myForm.getElementsByTagName("select")[0];
    var myPage = myForm.getElementsByTagName("input")[2];
    var width, height;
    switch(mySize.value) {
        case "640x480": width = "640"; height = "480"; break;
        case "800x600": width = "800"; height = "600"; break;
        case "1024x768": width = "1024"; height = "768"; break;
        case "1280x1024": width = "1280"; height = "1024"; break;
        case "1600x1200": width = "1600"; height = "1200"; break;
        default: width = ""; height = ""
    }
    myUrl = "?action=slides&page_id=" + myPage.value;
    myArgs = "height=" + height + ",width=" + width + ",location=no,menubars=no,scrollbars=yes,toolbars=no,resizable=no,titlebar=no";
    myTarget = "SlideShow";
    newWindow = open(myUrl, myTarget, myArgs);
    newWindow.focus();
}
</script>
<form>
${ \ CGI::popup_menu(
         -name => 'size',
         -values => [qw(640x480 800x600 1024x768 1280x1024 1600x1200)]
     )
 }
<input type="button" name="button" value="START" onclick="startSlides()">
<input type="hidden" name="action" value="slides">
<input type="hidden" name="page_id" value="$page_id">
</form>
END
    \ $html;
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
    $self->split_method($text,
        qr{(![A-Z][a-z]+[A-Z]\w+)},
        'no_wiki_link_format',
    );
}

sub no_wiki_link_format {
    my ($self, $text) = @_;
    $text =~ s#!##;
    return $text;
}

sub wiki_link {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{([A-Z][a-z]+[A-Z]\w+)},
        'wiki_link_format',
    );
}

sub force_wiki_link {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{\[([\w-]+)\]},
        'wiki_link_format',
    );
}

sub wiki_link_format {
    my ($self, $text) = @_;
    return qq{<a href="?$text">$text</a>};
}

sub no_http_link {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{(!http://\S+?(?=[),.:;]?\s|$))}m,
        'no_http_link_format',
    );
}

sub no_http_link_format {
    my ($self, $text) = @_;
    $text =~ s#!##;
    return $text;
}

sub http_link {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{(http://\S+?(?=[),.:;]?\s|$))}m,
        'http_link_format',
    );
}

sub http_link_format {
    my ($self, $text) = @_;
    if ($text =~ /\.(jpg|gif|jpeg|png)/) {
        return $self->img_format($text);
    }
    else {
        return $self->link_format($text, $text);
    }
}

sub img_format {
    my ($self, $url) = @_;
    return qq{<img src="$url">};
}

sub link_format {
    my ($self, $text, $url) = @_;
    return qq{<a href="$url">$text</a>};
}

sub named_http_link {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{(\[.*?http:\S.*?\])},
        'named_http_link_format',
    );
}

sub named_http_link_format {
    my ($self, $text) = @_;
    my $link = '';
    $link = $2 if $text =~ s#^\[(.*)(http://\S+)(.*)\]$#$1$3#;
    $link = $2 if $text =~ s#^\[(.*)http:(\S+)(.*)\]$#$1$3#;
    return $self->link_format($text, $link);
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
    $self->split_method($text,
        qr{(^ +[^ \n].*?\n)(?=[^ \n]|$)}ms,
        'code_format',
    );
}

sub code_format {
    my ($self, $text) = @_;
    $self->code_postformat($self->code_preformat($text));
}

sub code_preformat {
    my ($self, $text) = @_;
    my @indents = $text =~ /^( +)[^ \n]/gm;
    my $indent = 10000;
    for (@indents) {
        $indent = length($_) if length($_) < $indent;
    }
    $text =~ s/^ {$indent}//gm;
    return $self->escape_html($text);
}

sub code_postformat {
    my ($self, $text) = @_;
    return "<blockquote><pre>$text</pre></blockquote>\n";
}

sub escape_html {
    my ($self, $text) = @_;
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text;
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
            $_ = $self->lists_format($text);
        }
        $_;
    }
    split m!(^[0\*]+ .*?\n)(?=(?:[^0\*]|$))!ms, $text;
}

sub lists_format {
    my ($self, $text) = @_;
    return $text;
}

sub paragraph {
    my ($self, $text) = @_;
    my $switch = 0;
    return map {
        unless ($switch++ % 2) {
            $_ = $self->paragraph_format($_);
        }
        $_;
    }
    split m!(\n\s*\n)!ms, $text;
}

sub paragraph_format {
    my ($self, $text) = @_;
    return "<p>\n$_\n</p>\n";
}

sub horizontal_line {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{(^----+\n)}m,
        'horizontal_line_format',
    );
}

sub horizontal_line_format {
    my ($self, $text) = @_;
    return "<hr>\n";
}

sub comment {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{(^\# .*\n)}m,
        'comment_line_format',
    );
}

sub comment_line_format {
    my ($self, $text) = @_;
    $text =~ s/\# (.*)/<!-- $1 -->/;
    return $text;
}

sub header_1 {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{^= (.*) =\n}m,
        'header_1_format',
    );
}

sub header_1_format {
    my ($self, $text) = @_;
    return "<h1>$text</h1>\n";
}

sub header_2 {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{^== (.*) ==\n}m,
        'header_2_format',
    );
}

sub header_2_format {
    my ($self, $text) = @_;
    return "<h2>$text</h2>\n";
}

sub header_3 {
    my ($self, $text) = @_;
    $self->split_method($text,
        qr{^=== (.*) ===\n}m,
        'header_3_format',
    );
}

sub header_3_format {
    my ($self, $text) = @_;
    return "<h3>$text</h3>\n";
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
