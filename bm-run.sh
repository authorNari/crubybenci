#!/bin/sh

[ -r bmlog ] || mkdir bmlog

start_rev=$(git log -1|grep -o 'trunk@[0-9]*'|cut -d@ -f 2)
done=$(cat REVISION)

[ $start_rev -le $done ] && exit 1

while :
do
    rev=$(git log -1|grep -o 'trunk@[0-9]*'|cut -d@ -f 2)

    if [ $rev -le $done ]
    then
       echo $start_rev > REVISION
       break
    fi

    make -j 2
    if [ $? -ne 0 ]
    then
        git reset --hard 'HEAD~'
        continue
    fi

    if [ ! -r "bmlog/bm-${rev}.log" ]
    then
        ruby benchmark/driver.rb -r 3 -v -o "bmlog/bm-${rev}.log" --executables="r${rev}::./ruby -I./lib -I. -I.ext/common ./tool/runruby.rb --extout=.ext --;r${rev}-nogems::./ruby -I./lib -I. -I.ext/common ./tool/runruby.rb --extout=.ext -- --disable-gems" --pattern='bm_' --directory=./benchmark
        make clean
        git reset --hard 'HEAD~5'
    else
        git reset --hard 'HEAD~'
    fi

    while :
    do
        [ "$(git log -1 --format="%an")" = "svn" ] || break
        git reset --hard 'HEAD~'
    done
done
