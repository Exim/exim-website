#!/usr/bin/perl
#
# Test a regexp against a file (message)
#
use strict;
use FileHandle;
use Carp;

my $refile = shift;
my $infile = shift;

my $rfh = FileHandle->new($refile, 'r')|| croak;
my @relines = <$rfh>;
grep(s/\s*\#.*$//, @relines);
chomp(@relines);
my $repat = join('', @relines);
my $re = qr{$repat}ix;

my $infh = FileHandle->new($infile, 'r')|| croak;
my $in = join('', <$infh>);
$in =~ tr/\r\n/ /;

print "no " unless ($in =~ /$re/);
print "match\n";
