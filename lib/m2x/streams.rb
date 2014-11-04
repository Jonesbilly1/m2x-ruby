# Wrapper for AT&T M2X Data Streams API
#
# See https://m2x.att.com/developer/documentation/device for AT&T M2X
# HTTP Stream API documentation.
class M2X::Client::Streams
  # Creates a new M2X Stream API Wrapper
  def initialize(client)
    @client = client
  end

  # Return a list of the associated streams for the supplied device
  def list(device_id)
    @client.get("/devices/#{URI.encode(device_id)}/streams")
  end

  # Return the details of the supplied stream
  def view(device_id, name)
    @client.get("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}")
  end

  # Update stream's properties
  #
  # If the stream doesn't exist it will create it. See
  # https://m2x.att.com/developer/documentation/device#Create-Update-Data-Stream
  # for details.
  def update(device_id, name, params={})
    @client.put("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}", {}, params, "Content-Type" => "application/json")
  end
  alias_method :create, :update

  # Delete the stream (and all its values) from the device
  def delete_stream(device_id, name)
    @client.delete("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}")
  end

  # List values from an existing data stream associated with a
  # specific device, sorted in reverse chronological order (most
  # recent values first).
  #
  # The values can be filtered by using one or more of the following
  # optional parameters:
  #
  # * `start` An ISO 8601 timestamp specifying the start of the date
  # * range to be considered.
  #
  # * `end` An ISO 8601 timestamp specifying the end of the date
  # * range to be considered.
  #
  # * `limit` Maximum number of values to return.
  def values(device_id, name, params={})
    @client.get("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}/values", params)
  end

  # Sample values from an existing data stream associated with a specific
  # device, sorted in reverse chronological order (most recent values first).
  #
  # This method only works for numeric streams
  #
  # Refer to the sampling endpoint documentation for allowed parameters
  def sampling(device_id, name, params={})
    @client.get("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}/sampling", params)
  end

  # Return count, min, max, average and standard deviation stats for the
  # values on an existing data stream.
  #
  # This method only works for numeric streams
  #
  # Refer to the stats endpoint documentation for allowed parameters
  def stats(device_id, name, params={})
    @client.get("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}/stats", params)
  end

  # Update the current value of the specified stream. The timestamp
  # is optional. If ommited, the current server time will be used
  def update_value(device_id, name, value, timestamp=nil)
    params = { value: value }

    params[:at] = timestamp if timestamp

    @client.put("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}/value", nil, params, "Content-Type" => "application/json")
  end

  # Post multiple values to a single stream
  #
  # This method allows posting multiple values to a stream
  # belonging to a device. The stream should be created before
  # posting values using this method. The `values` parameter is a
  # hash with the following format:
  #
  #     {
  #       { "at": <Time in ISO8601>, "value": x },
  #       { "at": <Time in ISO8601>, "value": y },
  #       [ ... ]
  #     }
  def post_values(device_id, name, values)
    params = { values: values }
    @client.post("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}/values", nil, params, "Content-Type" => "application/json")
  end

  # Delete values in a stream by a date range
  # The `start` and `stop` parameters should be ISO8601 timestamps
  def delete_values(device_id, name, start, stop)
    params = { from: start, end: stop }
    @client.delete("/devices/#{URI.encode(device_id)}/streams/#{URI.encode(name)}/values", nil, params, "Content-Type" => "application/json")
  end
end
