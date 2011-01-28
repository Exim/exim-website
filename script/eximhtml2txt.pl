#!/usr/bin/env perl
#
use strict;
use warnings;

use HTML::FormatText;
use HTML::TreeBuilder;

sub process_chapter {
    my $fn = shift;

    my $tree = HTML::TreeBuilder->new->parse_file($fn);
    my ($chapter) = $tree->look_down( "_tag", "div", "class", "chapter", );
    return '' unless ($chapter);
    my $formatter = HTML::FormatText->new( leftmargin => 0, rightmargin => 72 );

    my $text = $formatter->format($chapter);
    $tree->delete;
    return $text;
}

my $dir = shift;
foreach my $fn ( glob("$dir/ch*.html") ) {
    print "=" x 72, "\n";
    print $fn, "\n";
    print "=" x 72, "\n";
    print process_chapter($fn);
    print "-" x 72, "\n";
}
