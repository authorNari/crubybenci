#!/bin/sh

cat <<END > index.html
<html>
<haed>
<title>CRuby Benchmark CI</title>
</head>
<body>
<p>All scripts are here (<a href="https://github.com/authorNari/crubybenci">https://github.com/authorNari/crubybenci</a>)</p>
<pre>Benchmark options:
-r 5 -v --executables="r\${rev}::./ruby -I./lib -I. -I.ext/common ./tool/runruby.rb --extout=.ext --"</pre>
END

echo "<p>uname -a : $(uname -a)</p>" >> index.html
echo "<p>Updated at : $(date --rfc-3339 seconds)</p>" >> index.html

for i in *.plot
do
    ipng="${i%.plot}.png"
    echo '<a name="'$i'"><a href="dest/'$i'">'$i'</a></a><br/>' >> index.html
    echo '<img src="dest/'$ipng'" /><br />' >> index.html
    rm src.dat
    echo 'set terminal png' >> src.dat
    echo 'set output "'$ipng'"' >> src.dat
    echo 'set title "'${i%.plot}'"' >> src.dat
    echo 'set xtics rotate by 260' >> src.dat
    echo 'set yrange [0:*]' >> src.dat
    echo 'plot "'$i'" using 1:2 title "" with lines' >> src.dat
    gnuplot src.dat
done

echo '</body></html>' >> index.html
