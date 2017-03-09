require_relative "./resource"

# Wrapper for {https://m2x.att.com/developer/documentation/v2/device M2X Data Streams} API.
class M2X::Client::Stream < M2X::Client::Resource

  class << self
    #
    # Method for {https://m2x.att.com/developer/documentation/v2/device#View-Data-Stream View Data Streams} endpoint.
    #
    # @param {Client} client Client API
    # @param (String) device device to fetch
    # @param (String) name of the stream to be fetched
    # @return {Stream} fetched stream
    #
    def fetch(client, device, name)
      res = client.get("#{device.path}/streams/#{URI.encode(name)}")

      new(client, device, res.json) if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/device#List-Data-Streams List Data Streams} endpoint.
    #
    # @param {Client} client Client API
    # @param (String) device device to get its data streams
    # @return (Array) List of {Stream} objects
    #
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

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Create-Update-Data-Stream Create Update Data Stream} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Stream} The newly created stream
  #
  def update!(params)
    res = @client.put(path, {}, params, "Content-Type" => "application/json")

    @attributes = res.json if res.status == 201
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#List-Data-Stream-Values List Data Stream Values} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) List of values from the stream
  #
  def values(params={})
    @client.get("#{path}/values", params)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Data-Stream-Sampling Data Stream Sampling} endpoint.
  # This method only works for numeric streams
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) List of sample values from the stream
  #
  def sampling(params)
    @client.get("#{path}/sampling", params)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Data-Stream-Stats Data Stream Stats} endpoint.
  # Returns the count, min, max, average and standard deviation stats for the
  # values of the stream.
  # This method only works for numeric streams
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) Stats of the stream
  #
  def stats(params={})
    @client.get("#{path}/stats", params)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Update-Data-Stream-Value Update Data Stream Value} endpoint.
  # The timestamp is optional. If omitted, the current server time will be used
  #
  # @param (String) value Value to be updated
  # @param (String) timestamp Current Timestamp
  # @return void
  #
  def update_value(value, timestamp=nil)
    params = { value: value }

    params[:timestamp] = timestamp if timestamp

    @client.put("#{path}/value", nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Post-Data-Stream-Values Post Data Stream Values} endpoint.
  # Post multiple values to the stream
  # The `values` parameter is an array with the following format:
  #     [
  #       { "timestamp": <Time in ISO8601>, "value": x },
  #       { "timestamp": <Time in ISO8601>, "value": y },
  #       [ ... ]
  #     ]
  #
  # @param values The values being posted, formatted according to the API docs
  # @return {Response} The API response, see M2X API docs for details
  #
  def post_values(values)
    params = { values: values }

    @client.post("#{path}/values", nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for {https://m2x.com/developer/documentation/v2/device#Delete-Data-Stream-Values Delete Data Stream Values} endpoint.
  # The `start` and `stop` parameters should be ISO8601 timestamps
  #
  # @param (String) start from time to delete the data
  # @param (String) stop end time to delete the data
  # @return {Response} The API response, see M2X API docs for details
  #
  def delete_values!(start, stop)
    params = { from: start, end: stop }

    @client.delete("#{path}/values", nil, params, "Content-Type" => "application/json")
  end
end
