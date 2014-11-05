# Wrapper for AT&T M2X Data Streams API
#
# See https://m2x.att.com/developer/documentation/device for AT&T M2X
# HTTP Stream API documentation.
class M2X::Client::Stream

  class << self
    def client
      @client ||= M2X::Client
    end

    def path(device_id, name=nil)
      base = "#{::M2X::Client::Device::PATH}/#{URI.encode(device_id)}/streams"
      base << "/#{URI.encode(name)}" if name
      base
    end

    # Return the details of the supplied stream
    def fetch(device_id, name)
      res = client.get("#{path(device_id, name)}")
      if res.success?
        json = res.json

        new(device_id, json["name"], json)
      end
    end

    # List all the streams that belong to the specified device
    def list(device_id)
      res = client.get("#{path(device_id)}")

      res.json["streams"].map{ |atts| new(device_id, atts["name"], atts) } if res.success?
    end

    # Update a Stream
    #
    # If the stream doesn't exist it will be created. In that case, a new instance of Stream will be returned
    # See https://m2x.att.com/developer/documentation/device#Create-Update-Data-Stream
    def update(device_id, name, params={})
      res = client.put("#{path(device_id, name)}", nil, params, "Content-Type" => "application/json")

      return res unless res.status == 201

      json = res.json

      new(device_id, json["name"], json)
    end
  end

  def client
    self.class.client
  end

  attr_accessor :device_id
  attr_accessor :name
  attr_accessor :attributes

  def initialize(device_id, name, attributes)
    @device_id  = device_id
    @name       = name
    @attributes = attributes
  end

  def base_path
    @base_path ||= self.class.path(@device_id, @name)
  end

  # Update stream's properties
  def update(params={})
    client.put(base_path, {}, params, "Content-Type" => "application/json")
  end

  # Delete the stream (and all its values)
  def delete
    client.delete(base_path)
  end

  # List values from the stream, sorted in reverse chronological order
  # (most recent values first).
  #
  # Refer to the Stream documentation for a list of allowed parameters
  def values(params={})
    client.get("#{base_path}/values", params)
  end

  # Sample values from the stream, sorted in reverse chronological order
  # (most recent values first).
  #
  # This method only works for numeric streams
  #
  # Refer to the Stream documentation for a list of allowed parameters
  def sampling(params={})
    client.get("#{base_path}/sampling", params)
  end

  # Return count, min, max, average and standard deviation stats for the
  # values of the stream.
  #
  # This method only works for numeric streams
  #
  # Refer to the Stream documentation for a list of allowed parameters
  def stats(params={})
    client.get("#{base_path}/stats", params)
  end

  # Update the current value of the stream. The timestamp
  # is optional. If ommited, the current server time will be used
  def update_value(value, timestamp=nil)
    params = { value: value }

    params[:at] = timestamp if timestamp

    client.put("#{base_path}/value", nil, params, "Content-Type" => "application/json")
  end

  # Post multiple values to the stream
  #
  # The `values` parameter is an array with the following format:
  #
  #     [
  #       { "at": <Time in ISO8601>, "value": x },
  #       { "at": <Time in ISO8601>, "value": y },
  #       [ ... ]
  #     ]
  def post_values(values)
    params = { values: values }

    client.post("#{base_path}/values", nil, params, "Content-Type" => "application/json")
  end

  # Delete values in a stream by a date range
  # The `start` and `stop` parameters should be ISO8601 timestamps
  def delete_values(start, stop)
    params = { from: start, end: stop }

    client.delete("#{base_path}/values", nil, params, "Content-Type" => "application/json")
  end
end
