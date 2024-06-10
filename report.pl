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
	my @r = split(/,/, $_);
	$km += $r[4];
	$ping += $r[5];
	$dlt += $r[6];
	$ult += $r[7];
	$i++;
}

print qq{Samples:\t$i
Download avg:\t} . ($dlt / $i) . qq{
Upload avg:\t} . ($ult / $i) . qq{
Ping avg:\t} . ($ping / $i) . qq{
Distance avg:\t} . ($km / $i) . qq{km
};
