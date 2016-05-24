#! /usr/bin/env ruby

require "m2x"

KEY     = ENV.fetch("KEY")
DEVICE  = ENV.fetch("DEVICE")
COLLECTION = ENV.fetch["COLLECTION"]

client = M2X::Client.new(KEY)

puts "Removing device from collection: #{COLLECTION}"

res = client.remove_device(COLLECTION, DEVICE, {})

puts "Status Code: #{res.status}"
