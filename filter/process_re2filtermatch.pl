#!/usr/bin/perl
#
use strict;

my $re;
while(<>) {
    chomp();
    # dispose of comments with their leading spaces
    s/\s+\#.*$//;
    # recode \" -> "
    s/\\\"/\"/g;
    # double all \ (twice)
    s/\\/\\\\/g;
    s/\\/\\\\/g;
    # escape " again
    s/\"/\\\"/g;
    # remove all space
    s/\s+//g;
    # add to re
    $re .= $_;
}
print "\"$re\"\n";
