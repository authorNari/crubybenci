# -*- coding: utf-8 -*-

require_relative 'config'

dirname = ARGV.shift
x_label_every = (ARGV.shift || 1).to_i

def logfile_to_hash(filepath)
  STDERR.puts filepath
  Hash[*open(filepath, &:read).each_line.drop_while {|i| ! (/\Abenchmark results:/ =~ i) }[3..-3]\
                              .map {|i| bmname, *res, _ = i.chomp.split(/\t/); [bmname, res] }.flatten(1)]
end

# all
#   {'bm_app_answer' => {rev => [gemrev]}, ...}
all = Dir.glob(File.join(dirname, 'bm-[0-9]*.log')).each.with_object(Hash.new{{}}) do |logfile, obj|
  rev = logfile.slice(/\d+/).to_i
  begin
    h = logfile_to_hash(logfile)
    bm_names = h.keys.sort
    bm_names.each do |bmname|
      o = obj[bmname]
      gemrev, _ = h[bmname].map(&:to_f)
      o[rev] = [gemrev]
      obj[bmname] = o
    end
  rescue
  end
end

all.each do |bmname, res|
  File.open(File.join(DESTDIR, bmname + ".plot"), "w") do |f|
    f.puts '"Revision" "--enable-gems"'
    res.sort_by {|(rev,_)| rev}.map do |*v|
      v.join(' ')
    end.each_slice(x_label_every) {|(h, *rest)|
      f.puts h
      f.puts rest.join("\n").gsub(/^[0-9]+/,'""') unless rest.empty?
    }
  end
end
