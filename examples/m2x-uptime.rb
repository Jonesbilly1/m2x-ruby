#! /usr/bin/env ruby

#
# See https://github.com/attm2x/m2x-ruby/blob/master/README.md#example-usage
# for instructions
#

require "time"
require "m2x"

API_KEY = "<YOUR-DEVICE-API-KEY>"
DEVICE  = "<YOUR-DEVICE-ID>"

m2x = M2X::Client.new(API_KEY)

@run = true
trap(:INT) { @run = false }

# Match `uptime` load averages output for both Linux and OSX
UPTIME_RE = /(\d+\.\d+),? (\d+\.\d+),? (\d+\.\d+)$/

def load_avg
  `uptime`.match(UPTIME_RE).captures
end

# Create the streams if they don't exist
m2x.devices.update_stream(DEVICE, "load_1m")
m2x.devices.update_stream(DEVICE, "load_5m")
m2x.devices.update_stream(DEVICE, "load_15m")

while @run
  load_1m, load_5m, load_15m = load_avg

  # Write the different values into AT&T M2X
  now = Time.now.iso8601

  values = {
    load_1m:  [ { value: load_1m,  timestamp: now } ],
    load_5m:  [ { value: load_5m,  timestamp: now } ],
    load_15m: [ { value: load_15m, timestamp: now } ]
  }

  res = m2x.devices.post_updates(DEVICE, values)

  abort res.json["message"] unless res.code == 202

  sleep 1
end

puts
