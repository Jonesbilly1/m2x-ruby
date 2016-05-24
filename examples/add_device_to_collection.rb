#! /usr/bin/env ruby

require "m2x"

KEY         = ENV.fetch("KEY")
DEVICE      = ENV.fetch("DEVICE")
COLLECTION  = ENV.fetch("COLLECTION")

client = M2X::Client.new(KEY)
collection = client.collection(COLLECTION)

puts "Adding device to collection: #{COLLECTION}"

res = collection.add_device(COLLECTION, DEVICE, {})

puts "Status Code: #{res.status}"
