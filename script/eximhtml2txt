#!/usr/bin/env perl
#
use strict;
use warnings;

use File::Spec;
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

sub chapters_in_order {
    my $dir = shift;

    opendir DIR, $dir or die "opendir($dir) failed: $!\n";
    my @numeric = sort grep {/^ch\d+\.html$/} readdir(DIR);
    closedir(DIR) or die "closedir($dir) failed: $!\n";

    my @results = map {
        $_ = File::Spec->catfile($dir, $_);
        if (-l $_) {
            my $t;
            eval { $t = readlink $_ };
            $_ = File::Spec->rel2abs($t, $dir) if defined $t;
        }
        $_
    } @numeric;
    return @results;
}


my $dir = shift;
die "Need a directory\n" unless defined $dir;

foreach my $fn ( chapters_in_order($dir) ) {
    print "=" x 72, "\n";
    print $fn, "\n";
    print "=" x 72, "\n";
    print process_chapter($fn);
    print "-" x 72, "\n";
}
