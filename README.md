# CRuby Benchamrk CI

Please see: http://crubybenci.github.com/

Most codes are made by k-tsj (https://gist.github.com/3846866). Thanks!!

# Usage

    cd /tmp
    git clone git://github.com/ruby/ruby.git
    cd ruby
    autoconf
    ./configure --disable-install-rdoc
    sh path/to/bm-run.sh
    ^C
    mkdir /tmp/dest
    ruby path/to/bm-merge.rb /tmp/ruby/bmlog 10
    cd /tmp/dest
    sh path/to/bm-make-graph.sh
