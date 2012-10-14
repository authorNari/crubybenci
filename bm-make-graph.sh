#!/bin/sh

cat <<END > index.html
<html>
<haed>
<title>CRuby Benchmark CI</title>
</head>
<body>
<p>All scripts are here (<a href="https://gist.github.com/3887044">https://gist.github.com/3887044</a>)</p>
<pre>Benchmark options:
-r 3 -v --executables="r\${rev}::./ruby -I./lib -I. -I.ext/common ./tool/runruby.rb --extout=.ext --;r\${rev}-nogems::./ruby -I./lib -I. -I.ext/common ./tool/runruby.rb --extout=.ext -- --disable-gems"</pre>
END

echo "<p>uname -a : $(uname -a)</p>" >> index.html
echo "<p>Updated at : $(date --rfc-3339 seconds)</p>" >> index.html

for i in *.plot
do
    ipng="${i%.plot}.png"
    echo '<a href="dest/'$i'">'$i'</a><br/>' >> index.html
    echo '<img src="dest/'$ipng'" /><br />' >> index.html
    rm src.dat
    echo 'set terminal png' >> src.dat
    echo 'set output "'$ipng'"' >> src.dat
    echo 'set title "'${i%.plot}'"' >> src.dat
    echo 'set xtics rotate by 260' >> src.dat
    echo 'plot "'$i'" using 1:2 title "--enable-gems" with lines, "'$i'" using 1:3 title "--disable-gems" with lines' >> src.dat
    gnuplot src.dat
done

echo '</body></html>' >> index.html
