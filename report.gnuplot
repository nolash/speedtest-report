set xdata time
set xlabel "Time"
set ylabel "Bits per second"
set timefmt "%s"
set yrange [0.0:1000000000.0]
set format y '%.0f'
set y2tics
set ytics nomirror
set y2label "Distance"
set y2range [0:1000]
set xrange [1744000000:1744500000]
set origin 0,0
set size 1,1
plot \
	'dat.dat' using 1:2 title "Upload" with lines, \
	'dat.dat' using 1:3 title "Download" with lines, \
	'dat.dat' using 1:4 title "Km" with lines axis x1y2
pause -2
