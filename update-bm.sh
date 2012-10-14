#!/bin/sh

cd ruby

# git pulling
git pull origin trunk:bench

# setup
if [ -r Makefile ]
then
    autoconf
    ./configure --disable-install-rdoc --without-ext
fi
[ -r ../dest ] || mkdir ../dest

# run benchmarks
sh ../bm-run.sh
[ $? -ne 0 ] && exit 0

# merge bmlog
ruby ../bm-merge.rb bmlog

# make index.html
cd ../dest
sh ../bm-make-graph.sh
mv -f index.html ../index.html

# ship it!
cd ..
sh shipit.sh
