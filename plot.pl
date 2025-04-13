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

my $ts_min = 0;
my $ts = 0;

print "# timestamp\tdownload\tupload\n";
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
	$ts = $t->epoch;
	if ($ts_min == 0) {
		$ts_min = $ts;
	}
	print $ts . "\t" . $r[6+$m] . "\t" . $r[7+$m] . "\t" . $r[4+$m] . "\n";
	$i++;
}

close(F);

open(F, '>', 'report.gnuplot');
print F qq{set xdata time
set xlabel "Time"
set ylabel "Bits per second (bps)"
set timefmt "%s"
set yrange [0.0:1000000000.0]
set format y '%.0f'
set y2tics
set ytics nomirror
set y2label "Distance (km)"
set y2range [0:1000]
set xrange [$ts_min:$ts]
set size 1,1
set term svg size 1000,400
set output 'samples.svg'
plot \\
	'samples.dat' using 1:2 title "Upload" with lines, \\
	'samples.dat' using 1:3 title "Download" with lines, \\
	'samples.dat' using 1:4 title "Km" with lines axis x1y2
};
close(F);

system('gnuplot', 'report.gnuplot');
