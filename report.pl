#!/usr/bin/env perl

use v5.10.1;
use warnings;

# Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,Upload,Share,IP Address

my $help_detail = qq{

file should be one or more records per line from output of speedtest-cli --csv
};

if ($#ARGV < 0) {
	die "usage: $0 <file>" . $help_detail;
}

my $fp = $ARGV[0];

if (! -f $fp) {
	die "no such file " . $fp . $help_detail;
}

open(F, "<$fp");

my $i = 0;
my $dlt = 0;
my $dlu = 0;
my $km = 0;
my $ping = 0;

while (<F>) {
	my $m = 0;
	my @r = split(/,/, $_);
	if ($#r == 10) {
		$m = 1;
	}
	$km += $r[4+$m];
	$ping += $r[5+$m];
	$dlt += $r[6+$m];
	$ult += $r[7+$m];
	$i++;
}

print qq{Samples:\t$i
Download avg:\t} . ($dlt / $i) . qq{
Upload avg:\t} . ($ult / $i) . qq{
Ping avg:\t} . ($ping / $i) . qq{
Distance avg:\t} . ($km / $i) . qq{km
};
