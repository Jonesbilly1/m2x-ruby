#! /usr/bin/env ruby

require "m2x"

KEY     = ENV.fetch("KEY")
DEVICE  = ENV.fetch("DEVICE")
STREAMS = ENV["STREAMS"]

client = M2X::Client.new(KEY)

device = client.device(DEVICE)

params = {}
params = { streams: STREAMS.split(",").map(&:strip) } unless STREAMS.to_s.empty?

res = device.values_export(params)

location = res.headers["location"][0]

puts "The job location is in #{location}"

job = client.job(location.split("/").last)

loop do
  state = job["state"]

  break if state == "complete"

  abort "Job has failed to complete" if state == "failed"

  puts "Job state is #{state}, waiting for completion"
  sleep 5
  job.view
end

puts "The job has been completed! You can download the result from #{job["result"]["url"]}"
