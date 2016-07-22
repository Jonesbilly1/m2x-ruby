#! /usr/bin/env ruby

require "m2x"

KEY            = ENV.fetch("KEY")
DEVICE         = ENV.fetch("DEVICE")
FROM_TIMESTAMP = ENV.fetch("FROM")
END_TIMESTAMP  = ENV.fetch("END")

client = M2X::Client.new(KEY)
device = client.device(DEVICE)

puts "Deleting location from #{FROM_TIMESTAMP} to #{END_TIMESTAMP}"

res = device.delete_locations!(FROM_TIMESTAMP, END_TIMESTAMP)

puts "Status Code: #{res.status}"
