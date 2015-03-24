# AT&T M2X Ruby Tutorial

To follow along with this AT&T M2X Ruby tutorial, you'll need the `m2x` gem installed (run `gem install m2x`) an AT&T M2X account (sign up for one [here](https://m2x.att.com/signup)), and the Master API Key from your account (you can find it [here](https://m2x.att.com/account#master-keys) after logging in). Once you have all this, you're ready to begin.

## Getting Started

Open your Ruby REPL of choice - the `irb` command is included with Ruby, but you can use a different REPL like `pry` if you prefer. Using a REPL is a great way to experiment with the API in an interactive way, where you can easily see the results of all your API calls.
```shell
$ irb
irb>
```

Let's import the `m2x` library, so we can start using the classes in the `M2X` namespace.
```ruby
irb> require 'm2x'
=>  true
```

Now that the library is loaded, let's create an instance of `M2X::Client` with the Master API Key we have handy.
```ruby
irb> my_api_key = "0123456789abcdef0123456789abcdef" # Use your own key here!
=>  "0123456789abcdef0123456789abcdef"
irb> client = M2X::Client.new(my_api_key)
=>  <M2X::Client:0x007fb753101708 ...>
```

## Creating a Device

Let's use the client object create a new device. We must provide a name and a visibility level, and we can add an optional description here as well.
```ruby
irb> device = client.create_device(
       name: "My Sensor",
       visibility: "public",
       description: "Created in the AT&T M2X Ruby Tutorial",
     )
=>  <M2X::Client::Device: {
      "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0",
      "name"=>"My Sensor",
      "status"=>"enabled",
      "serial"=>nil,
      "tags"=>nil,
      "location"=>{},
      "visibility"=>"public",
      "description"=>"Created in the AT&T M2X Ruby Tutorial",
      "created"=>"2015-03-24T00:04:14.654Z",
      "updated"=>"2015-03-24T00:04:14.654Z",
      "last_activity"=>"2015-03-24T00:04:14.654Z",
      "id"=>"cad0c5a8fd8968103e8b3994325e00f0",
      "streams"=>{
        "count"=>0,
        "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/streams"
      },
      "key"=>"c61ea728159cf1918ee0c18ed5552dde",
      "triggers"=>{
        "count"=>0,
        "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/triggers"
      }
    }>
```

Now that this device exists, we can get an identical object handle to it at any time (or from any other program) by using the client object to fetch it by its ID.
```ruby
irb> device = client.device("cad0c5a8fd8968103e8b3994325e00f0")
=>  <M2X::Client::Device: {
      "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0",
      "name"=>"My Sensor",
      "status"=>"enabled",
      "serial"=>nil,
      "tags"=>nil,
      "location"=>{},
      "visibility"=>"public",
      "description"=>"Created in the AT&T M2X Ruby Tutorial",
      "created"=>"2015-03-24T00:04:14.654Z",
      "updated"=>"2015-03-24T00:04:14.654Z",
      "last_activity"=>"2015-03-24T00:04:14.654Z",
      "id"=>"cad0c5a8fd8968103e8b3994325e00f0",
      "streams"=>{
        "count"=>0,
        "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/streams"
      },
      "key"=>"c61ea728159cf1918ee0c18ed5552dde",
      "triggers"=>{
        "count"=>0,
        "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/triggers"
      }
    }>
```

We can pull arbitrary attributes out of this device object from our program using Ruby's element access syntax (`collection[key]`).
```ruby
irb> device["id"]
=> "cad0c5a8fd8968103e8b3994325e00f0"
irb> device["status"]
=> "enabled"
irb> device["created"]
=> "2015-03-24T00:04:14.654Z"
irb> device["streams"]
=>  {
      "count"=>0,
      "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/streams"
    }
irb> device["streams"]["count"]
=>  0
```

We can use element access for attributes in more complex operations as well. Let's get the device IDs of all public devices in the M2X Device Catalog, as well as the number of streams each has, using Ruby's `map` function to convert the array of devices to an array of device IDs and stream counts.
```ruby
irb> M2X::Client::Device.catalog(client).map do |dev|
       [dev["id"], dev["streams"]["count"]]
     end
=>  [
      ["4d018012a8d8f969c3a508cc15431e9f", 1],
      ["8a1e527b1becdc0eb0eba0b7a10efbb1", 2],
      ["933e760c444999d84ca9c7980bc5831c", 1],
      ["38c55d43f0ba8004707305fe15ba0c51", 1],
      ["3bedbda67a8c1a902b10828d79da9410", 1],
      ["6f122d0531b51b4272526876c7ccd8a8", 1],
      ["a2852df27102179429b3a02641594044", 1],
      ["1fbb859cc5af9cf23c7d61a16d9b0c5c", 4],
      ["4b44c1ee777dd66bc0b08ed8eee7ea0f", 1],
      ["615bf2aec65eb2b2590e024833ea4998", 1],
      ["cad0c5a8fd8968103e8b3994325e00f0", 0],
      #...
    ]
```

After looking through the attributes of other devices, we notice that many of the others have location data listed in their attributes. Let's set the location of our own device.
```ruby
irb> res = device.update_location(
       name: "Storage Room",
       latitude: -37.9788423562422,
       longitude: -57.5478776916862,
     )
=>  <M2X::Client::Response:0x007f35c7cad560 ...>
```

This time, rather than getting a new resource object handle, we got a response object instead. This response object encapsulates the response from the API. We can use it to make sure our request was successful as well as get the response JSON data, if any.
```ruby
irb> res.success?
=>  true
irb> res.error?
=>  false
irb> res.status
=> 202 # This is the HTTP status code of the response
irb> res.json
=> {"status"=>"accepted"}
```

We were told the request succeeded, but let's check the `"location"` attribute of our device again, just to be sure.
```ruby
irb> device["location"]
=>  {}
```

It may suprise us that the `"location"` attribute is still empty. However, this makes sense: we've sent an update to the remote resource, but we haven't refreshed the attributes in our local object handle. Let's try refreshing and checking again.
```ruby
irb> device.refresh
=>  <M2X::Client::Device: ...>
irb> device["location"]
=>  {
      "name"=>"Storage Room",
      "latitude"=>-37.9788423562422,
      "longitude"=>-57.5478776916862,
      "elevation"=>nil,
      "timestamp"=>"2015-03-24T01:05:07.475Z"
    }
```

That's better. Incidentally, `M2X::Client::Device` has a `location` method that we could have used instead, which always fetches the latest location and returns it in the JSON data of a response object.
```ruby
irb> device.location.json["name"]
=>  "Storage Room"
irb> device.update_location(
       name: "Elsewhere",
       latitude: -37.9788423562422,
       longitude: -57.5478776916862,
     ).success?
=>  true
irb> device.location.json["name"]
=>  "Elsewhere"
```

## Creating Data Streams

Our device is set up now, but it's not that useful if it has no data streams to consume. Let's add a few, using the `M2X::Client::Device#create_stream` method.
```ruby
irb> device.streams
=>  []
irb> device.create_stream("temperature",
       unit: { label: "celsius", symbol: "C" }
     )
irb> device.create_stream("precipitation",
       type: "alphanumeric"
     )
irb> device.streams
=>  [
      <M2X::Client::Stream: {
        "name"=>"temperature",
        "display_name"=>nil,
        "value"=>nil,
        "latest_value_at"=>nil,
        "type"=>"numeric",
        "unit"=>{"label"=>"celsius", "symbol"=>"C"},
        "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/streams/temperature",
        "created"=>"2015-03-24T16:23:42.349Z",
        "updated"=>"2015-03-24T16:23:42.349Z"
      }>,
      <M2X::Client::Stream: {
        "name"=>"precipitation",
        "display_name"=>nil,
        "value"=>nil,
        "latest_value_at"=>nil,
        "type"=>"alphanumeric",
        "unit"=>{"label"=>nil, "symbol"=>nil},
        "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/streams/precipitation",
        "created"=>"2015-03-24T16:29:14.924Z",
        "updated"=>"2015-03-24T16:29:14.924Z"
      }>
    ]
```

Now that these streams exist, we can get object handles to them at any time (or from any other program) by using the device object to fetch them by name.
```ruby
irb> temperature = device.stream("temperature")
=>  <M2X::Client::Stream: {
      "name"=>"temperature",
      "display_name"=>nil,
      "value"=>nil,
      "latest_value_at"=>nil,
      "type"=>"numeric",
      "unit"=>{"label"=>"celsius", "symbol"=>"C"},
      "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/streams/temperature",
      "created"=>"2015-03-24T16:23:42.349Z",
      "updated"=>"2015-03-24T16:23:42.349Z"
    }>
irb> precipitation = device.stream("precipitation")
=>  <M2X::Client::Stream: {
      "name"=>"precipitation",
      "display_name"=>nil,
      "value"=>nil,
      "latest_value_at"=>nil,
      "type"=>"alphanumeric",
      "unit"=>{"label"=>nil, "symbol"=>nil},
      "url"=>"http://api-m2x.att.com/v2/devices/cad0c5a8fd8968103e8b3994325e00f0/streams/precipitation",
      "created"=>"2015-03-24T16:29:14.924Z",
      "updated"=>"2015-03-24T16:29:14.924Z"
    }>
```

Let's send a value to our precipitation stream to describe the weather we're seeing right now, then check that we can also read the value.
```ruby
irb> precipitation.update_value("rain").success?
=>  true
irb> precipitation.values.json
=>  {
      "limit"=>100,
      "end"=>"2015-03-24T16:46:50.872Z",
      "values"=>[
        {"timestamp"=>"2015-03-24T16:46:49.550Z", "value"=>"rain"}
      ]
    }
irb> precipitation.values.json["values"].first["value"]
=>  "rain"
```

Let's add some more data to our precipitation stream to describe some weather we've seen in the past few days, using timestamps to indicate specific times in the past. We'll need to load the `time` library in order to send the timestamps in `iso8601` format.
```ruby
irb> require 'time'
=>  true
irb> yesterday = Time.now - 24*60*60
=>  2015-03-23 09:52:00 -0700
irb> two_days_ago = yesterday - 24*60*60
=>  2015-03-24 09:52:00 -0700
irb> precipitation.update_value("heavy rain", yesterday.iso8601).success?
=>  true
irb> precipitation.update_value("snow", two_days_ago.iso8601).success?
=>  true
irb> precipitation.values.json
=>  {
      "limit"=>100,
      "end"=>"2015-03-24T16:53:21.542Z",
      "values"=>[
        {"timestamp"=>"2015-03-24T16:46:49.550Z", "value"=>"rain"},
        {"timestamp"=>"2015-03-23T16:51:49.000Z", "value"=>"heavy rain"},
        {"timestamp"=>"2015-03-22T16:51:49.000Z", "value"=>"snow"}
      ]
    }
irb> precipitation.values.json["values"].map { |entry| entry["value"] }
=> ["rain", "heavy rain", "snow"]
```

Note that the `"limit"=>100` attribute indicates that the maximum number of values we'll receive in the response is 100. If we like, we can specify a different limit in the method parameters, like if we wanted to fetch the latest value only (to save on bandwidth and memory).
```ruby
irb> precipitation.values(limit: 1).json
=>  {
      "limit"=>1,
      "end"=>"2015-03-24T16:55:36.402Z",
      "values"=>[
        {"timestamp"=>"2015-03-24T16:46:49.550Z", "value"=>"rain"}
      ]
    }
irb> precipitation.values(limit: 1).json["values"].first["value"]
=> "rain"
```

Now let's post some temperature readings from the same times, this time posting the entire batch of values in the same API call.
```ruby
irb> temperature.post_values([
       {"timestamp"=>"2015-03-24T16:46:49.550Z", "value"=> 5.8},
       {"timestamp"=>"2015-03-23T16:51:49.000Z", "value"=> 3.1},
       {"timestamp"=>"2015-03-22T16:51:49.000Z", "value"=>-2.5},
     ]).success?
=>  true
irb> temperature.values.json["values"].map { |entry| entry["value"] }
=>  [5.8, 3.1, -2.5]
```

For even more efficiency, we can post updates to multiple data streams in a single API call at the device level. Let's add temperature and precipitation data for the rest of the past week.
```ruby
irb> device.post_updates(values: {
       "precipitation"=>[
         {"timestamp"=>"2015-03-21T16:51:49.000Z", "value"=>"none"},
         {"timestamp"=>"2015-03-20T16:51:49.000Z", "value"=>"freezing rain"},
         {"timestamp"=>"2015-03-19T16:51:49.000Z", "value"=>"light rain"},
         {"timestamp"=>"2015-03-18T16:51:49.000Z", "value"=>"none"},
       ],
       "temperature"=>[
         {"timestamp"=>"2015-03-21T16:51:49.000Z", "value"=>-1.2},
         {"timestamp"=>"2015-03-20T16:51:49.000Z", "value"=>-0.3},
         {"timestamp"=>"2015-03-19T16:51:49.000Z", "value"=> 0.5},
         {"timestamp"=>"2015-03-18T16:51:49.000Z", "value"=> 1.1},
       ],
     }).success?
=>  true
irb> precipitation.values.json["values"].map { |entry| entry["value"] }
=>  ["rain", "heavy rain", "snow", "none", "freezing rain", "light rain", "none"]
irb> temperature.values.json["values"].map { |entry| entry["value"] }
=>  [5.8, 3.1, -2.5, -1.2, -0.3, 0.5, 1.1]
```

Because the `temperature` stream has `"type"=>"numeric"`, we can fetch calculated numerical statistics from the M2X API about the data in the stream.
```ruby
irb> temperature.stats.json
=>  {
      "end"=>"2015-03-24T18:02:49.010Z",
      "stats"=>{
        "count"=>7.0,
        "min"=>-2.5,
        "max"=>5.8,
        "avg"=>"0.928571E0",
        "stddev"=>2.576107
      }
    }
irb> average_temp = temperature.stats.json["stats"]["avg"].to_f
=>  0.928571
```

## Next Steps

We've seen that using a Ruby REPL is a great way to interactively explore the AT&T M2X API, and we've walked through some basic uses of the Ruby client library. However, this tutorial is by no means exhaustive, and there are many more features in both the M2X API and the Ruby client library for it.

Explore [the complete M2X API documentation](https://m2x.att.com/developer/documentation/v2/device) and [the Ruby client library source code on GitHub](https://github.com/attm2x/m2x-ruby) to learn more about what's possible with AT&T M2X in your Ruby applications.
