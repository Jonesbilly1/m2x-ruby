# Wrapper for AT&T M2X Data Streams API
# https://m2x.att.com/developer/documentation/v2/device
class M2X::Client::Stream < M2X::Client::Resource

  class << self
    # Get details of a specific data Stream associated with a device
    #
    # https://m2x.att.com/developer/documentation/v2/device#View-Data-Stream
    def fetch(client, device, name)
      res = client.get("#{device.path}/streams/#{name}")

      new(client, device, res.json) if res.success?
    end

    # Retrieve list of data streams associated with a device.
    #
    # https://m2x.att.com/developer/documentation/v2/device#List-Data-Streams
    def list(client, device)
      res = client.get("#{device.path}/streams")

      res.json["streams"].map{ |atts| new(client, device, atts) } if res.success?
    end
  end

  def initialize(client, device, attributes)
    @client     = client
    @device     = device
    @attributes = attributes
  end

  def path
    @path ||= "#{@device.path}/streams/#{ URI.encode(@attributes.fetch("name")) }"
  end

  # Update stream properties
  # (if the stream does not exist it gets created).
  #
  # https://m2x.att.com/developer/documentation/v2/device#Create-Update-Data-Stream
  def update!(params)
    res = @client.put(path, {}, params, "Content-Type" => "application/json")

    @attributes = res.json if res.status == 201
  end

  # List values from the stream, sorted in reverse chronological order
  # (most recent values first).
  #
  # https://m2x.att.com/developer/documentation/v2/device#List-Data-Stream-Values
  def values(params={})
    @client.get("#{path}/values", params)
  end

  # Sample values from the stream, sorted in reverse chronological order
  # (most recent values first).
  #
  # This method only works for numeric streams
  #
  # https://m2x.att.com/developer/documentation/v2/device#Data-Stream-Sampling
  def sampling(params)
    @client.get("#{path}/sampling", params)
  end

  # Return count, min, max, average and standard deviation stats for the
  # values of the stream.
  #
  # This method only works for numeric streams
  #
  # https://m2x.att.com/developer/documentation/v2/device#Data-Stream-Stats
  def stats(params={})
    @client.get("#{path}/stats", params)
  end

  # Update the current value of the stream. The timestamp
  # is optional. If omitted, the current server time will be used
  #
  # https://m2x.att.com/developer/documentation/v2/device#Update-Data-Stream-Value
  def update_value(value, timestamp=nil)
    params = { value: value }

    params[:at] = timestamp if timestamp

    @client.put("#{path}/value", nil, params, "Content-Type" => "application/json")
  end

  # Post multiple values to the stream
  #
  # The `values` parameter is an array with the following format:
  #
  #     [
  #       { "timestamp": <Time in ISO8601>, "value": x },
  #       { "timestamp": <Time in ISO8601>, "value": y },
  #       [ ... ]
  #     ]
  #
  # https://m2x.att.com/developer/documentation/v2/device#Post-Data-Stream-Values
  def post_values(values)
    params = { values: values }

    @client.post("#{path}/values", nil, params, "Content-Type" => "application/json")
  end

  # Delete values in a stream by a date range
  # The `start` and `stop` parameters should be ISO8601 timestamps
  #
  # https://m2x.com/developer/documentation/v2/device#Delete-Data-Stream-Values
  def delete_values!(start, stop)
    params = { from: start, end: stop }

    @client.delete("#{path}/values", nil, params, "Content-Type" => "application/json")
  end
end
