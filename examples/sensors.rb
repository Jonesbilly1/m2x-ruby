#! /usr/bin/env ruby

require "time"
require "m2x"

KEY     = ENV.fetch("KEY")
KITCHEN = ENV.fetch("KITCHEN")
GARAGE  = ENV.fetch("GARAGE")

client = M2X::Client.new(KEY)

kitchen = client.device(KITCHEN)
garage  = client.device(GARAGE)

# Create the streams if they don't exist
kitchen.create_stream("humidity")
kitchen.create_stream("temperature")
garage.create_stream("humidity")
garage.create_stream("temperature")
garage.create_stream("door_open")

door_open = garage.stream("door_open")

@run = true

stop = Proc.new { @run = false }

trap(:INT,  &stop)
trap(:TERM, &stop)

door_is_open = false

while @run
  now = Time.now.iso8601

  kitchen.post_updates(values: {
                                 humidity:    [ { timestamp: now, value: rand(0..100) } ],
                                 temperature: [ { timestamp: now, value: rand(0..24)  } ]
                               }
                       )

  garage.post_updates(values: {
                                humidity:    [ { timestamp: now, value: rand(0..100) } ],
                                temperature: [ { timestamp: now, value: rand(0..24)  } ]
                              }
                      )

  if rand > 0.75
    door_is_open = !door_is_open
    door_open.update_value(door_is_open ? 1 : 0)
  end

  sleep 2
end

