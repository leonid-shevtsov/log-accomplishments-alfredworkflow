#!/usr/bin/env ruby

require 'date'
require 'time'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: log.rb logfile message"

  opts.on("--file=FILE", "Use logfile") do |f|
    options[:file] = f
  end

  opts.on("--message=MESSAGE", "Set message") do |f|
    options[:message] = f
  end
end.parse!(ARGV)

fail OptionParser::MissingArgument if options[:file].nil? || options[:message].nil?

logfile = File.expand_path(options[:file])

date_line = "## #{Date.today}\n"
time = Time.now.strftime("%H:%M")
message_line = "* #{time} #{options[:message]}\n"

log = begin
  File.readlines(logfile)
rescue Errno::ENOENT
  []
end

if log[0] == date_line
  insertion_point = (log[2..-1].find_index("\n") || -3) + 2
  log.insert(insertion_point, message_line)
else
  log.unshift(date_line, "\n", message_line)
end

File.open(logfile, "w") { |f| f.puts(log.join) }

puts options[:message]
