#! /usr/bin/env ruby

require "m2x"

KEY         = ENV.fetch("KEY")
DEVICE      = ENV.fetch("DEVICE")
COLLECTION  = ENV.fetch["COLLECTION"]

client 		= M2X::Client.new(KEY)
collection 	= client.collection(COLLECTION)

puts "Removing device from collection: #{COLLECTION}"

res = collection.remove_device(COLLECTION, DEVICE, {})

puts "Status Code: #{res.status}"
