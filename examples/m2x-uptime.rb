#! /usr/bin/env ruby

#
# See https://github.com/attm2x/m2x-ruby/blob/master/README.md#example-usage
# for instructions
#

require "time"
require "m2x"

API_KEY = "<YOUR-FEED-API-KEY>"
FEED    = "<YOUR-FEED-ID>"

m2x = M2X.new(API_KEY)

@run = true
trap(:INT) { @run = false }

# Match `uptime` load averages output for both Linux and OSX
UPTIME_RE = /(\d+\.\d+),? (\d+\.\d+),? (\d+\.\d+)$/

def load_avg
  `uptime`.match(UPTIME_RE).captures
end

# Create the streams if they don't exist
m2x.feeds.update_stream(FEED, "load_1m")
m2x.feeds.update_stream(FEED, "load_5m")
m2x.feeds.update_stream(FEED, "load_15m")

while @run
  load_1m, load_5m, load_15m = load_avg

  # Write the different values into AT&T M2X
  now = Time.now.iso8601

  values = {
    load_1m:  [ { value: load_1m, at: now } ],
    load_5m:  [ { value: load_5m, at: now } ],
    load_15m: [ { value: load_15m, at: now } ]
  }

  res = m2x.feeds.post_multiple(FEED, values)

  abort res.json["message"] unless res.code == 202

  sleep 1
end

puts
