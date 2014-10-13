#!/usr/bin/env ruby

require 'time'
require 'chronic_duration'

minutes = ARGV[0] unless ARGV.length == 0

if minutes.nil? then
  puts "Usage: #{$0} minutes"
  exit 0
end

seconds = minutes.to_i * 60
future = Time.now + seconds + 2

while Time.now < future do
  Kernel.sleep(5)
  remaining = (future - Time.now).to_i
  rem_s = ChronicDuration.output(remaining)
  puts("Time remaining: #{rem_s}")
end

Kernel.exec("say time is up")

exit 0
