#!/usr/bin/env perl

use v5.10.1;
use warnings;
use DateTime;
use DateTime::Duration;
use DateTime::Format::Strptime;
use DateTime::Format::ISO8601;

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

my $days = $ARGV[1];
my $dt = undef;
if (defined $days) {
	if ($days!~/^\d+$/) {
		die "days must be numeric";
	}
	$dt = DateTime->now;
	$dt = DateTime::Format::Strptime->new(pattern=>"%Y-%m-%d")->parse_datetime($dt->ymd);
	$dt -= DateTime::Duration->new(days => $days);
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
	my $t = DateTime::Format::ISO8601->parse_datetime($r[3+$m]);
	if (defined $dt) {
		if ($dt > $t) {
			next;
		}
	}
	$km += $r[4+$m];
	$ping += $r[5+$m];
	$dlt += $r[6+$m];
	$ult += $r[7+$m];
	$i++;
}

close(F);

print qq{Samples:\t$i
Download avg:\t} . ($dlt / $i) . qq{
Upload avg:\t} . ($ult / $i) . qq{
Ping avg:\t} . ($ping / $i) . qq{
Distance avg:\t} . ($km / $i) . qq{km
};
