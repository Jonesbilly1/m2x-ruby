#! /usr/bin/env ruby

#
# See https://github.com/attm2x/m2x-ruby/blob/master/README.md#example-usage
# for instructions
#

require "time"
require "m2x"

M2X::Client.api_key  = "<YOUR-DEVICE-API-KEY>"

DEVICE  = "<YOUR-DEVICE-ID>"

puts "M2X::Client/#{M2X::Client::VERSION} example"

@run = true
trap(:INT) { @run = false }

# Match `uptime` load averages output for both Linux and OSX
UPTIME_RE = /(\d+\.\d+),? (\d+\.\d+),? (\d+\.\d+)$/

def load_avg
  `uptime`.match(UPTIME_RE).captures
end

m2x = M2X::Client

# Get the device
device = m2x.device[DEVICE]

# Create the streams if they don't exist
device.create_stream("load_1m")
device.create_stream("load_5m")
device.create_stream("load_15m")

while @run
  load_1m, load_5m, load_15m = load_avg

  # Write the different values into AT&T M2X
  now = Time.now.iso8601

  values = {
    load_1m:  [ { value: load_1m,  timestamp: now } ],
    load_5m:  [ { value: load_5m,  timestamp: now } ],
    load_15m: [ { value: load_15m, timestamp: now } ]
  }

  res = device.post_updates(values: values)

  abort res.json["message"] unless res.success?

  sleep 1
end

puts
