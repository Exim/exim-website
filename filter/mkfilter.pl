#!/usr/bin/perl
#
use strict;
use FileHandle;



sub process_refile {
    my $fn = shift;

    my $re;
    print STDERR "Opening $fn\n";
    my $fh = FileHandle->new($fn, 'r') || die $!;
    while (<$fh>) {
	chomp();
	# process includes
	if (/^\#include\s/) {
	    my($junk, $nfn) = split;
	    $re .= process_refile($nfn);
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



sub process_recfile {
    my $fn = shift;

    my $re;
    print STDERR "Opening $fn\n";
    my $fh = FileHandle->new($fn, 'r') || die $!;
    while (<$fh>) {
	chomp();
	# process includes
	if (/^\#include\s/) {
	    my($junk, $nfn) = split;
	    $re .= process_recfile($nfn);
	    next;
	}
	# skip comment only and blank lines
	next if (/^\#/);
	next if (/^\s*$/);
	$re .= "#\t$_\n";
    }
    return $re;
}



# main
{
    while(<>) {
	s/\[\[([a-z0-9_]+)\]\]/process_refile($1)/ge;
	s/\[\<([a-z0-9_]+)\>\]/process_recfile($1)/ge;
	print;
    }
}
