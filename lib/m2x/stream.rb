# Wrapper for AT&T M2X Data Streams API
#
# See https://m2x.att.com/developer/documentation/device for AT&T M2X
class M2X::Client::Stream < M2X::Client::Resource

  class << self
    # Return the details of the supplied stream
    def fetch(client, device, name)
      res = client.get("#{device.path}/streams/#{name}")

      new(client, device, res.json) if res.success?
    end

    # List all the streams that belong to the specified device
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

  # Update stream's properties
  # If the stream doesn't exist, it will be created
  def update!(params)
    res = @client.put(path, {}, params, "Content-Type" => "application/json")

    @attributes = res.json if res.status == 201
  end

  # List values from the stream, sorted in reverse chronological order
  # (most recent values first).
  #
  # Refer to the Stream documentation for a list of allowed parameters
  def values(params={})
    @client.get("#{path}/values", params)
  end

  # Sample values from the stream, sorted in reverse chronological order
  # (most recent values first).
  #
  # This method only works for numeric streams
  #
  # Refer to the Stream documentation for a list of allowed parameters
  def sampling(params)
    @client.get("#{path}/sampling", params)
  end

  # Return count, min, max, average and standard deviation stats for the
  # values of the stream.
  #
  # This method only works for numeric streams
  #
  # Refer to the Stream documentation for a list of allowed parameters
  def stats(params={})
    @client.get("#{path}/stats", params)
  end

  # Update the current value of the stream. The timestamp
  # is optional. If ommited, the current server time will be used
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
  def post_values(values)
    params = { values: values }

    @client.post("#{path}/values", nil, params, "Content-Type" => "application/json")
  end

  # Delete values in a stream by a date range
  # The `start` and `stop` parameters should be ISO8601 timestamps
  def delete_values!(start, stop)
    params = { from: start, end: stop }

    @client.delete("#{path}/values", nil, params, "Content-Type" => "application/json")
  end
end
