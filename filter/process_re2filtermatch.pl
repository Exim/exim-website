#!/usr/bin/perl
#
use strict;
use FileHandle;



sub process_file {
    my $fn = shift;

    my $re;
    print STDERR "Opening $fn\n";
    my $fh = FileHandle->new($fn, 'r') || die $!;
    while (<$fh>) {
	chomp();
	# process includes
	if (/^\#include\s/) {
	    my($junk, $nfn) = split;
	    $re .= process_file($nfn);
	    next;
	}
	# ignore comments starting at the begining of the line
	next if (/^\#/);
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
    return $re;
}



# main
{
    my $re;
    while($_ = shift) {
	$re .= process_file($_);
    }
    print "\"$re\"\n";
}
