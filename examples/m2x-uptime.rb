#! /usr/bin/env ruby

#
# See https://github.com/attm2x/m2x-ruby/blob/master/README.md#example-usage
# for instructions
#

require "m2x"

API_KEY = "<YOUR-FEED-API-KEY>"
FEED    = "<YOUR-FEED-ID>"

m2x = M2X.new(API_KEY)

@run = true
trap(:INT) { @run = false }

# Match `uptime` load averages output for both Linux and OSX
UPTIME_RE = /(\d+\.\d+),? (\d+\.\d+),? (\d+\.\d+)$/

while @run
  load_1m, load_5m, load_15m = `uptime`.match(UPTIME_RE).captures

  # Write the different values into AT&T M2X
  m2x.feeds.update_stream(FEED, "load_1m",  value: load_1m)
  m2x.feeds.update_stream(FEED, "load_5m",  value: load_5m)
  m2x.feeds.update_stream(FEED, "load_15m", value: load_15m)

  sleep 1
end

puts
