# Wrapper for AT&T M2X Devices API
#
# See https://m2x.att.com/developer/documentation/device for AT&T M2X
# HTTP Device API documentation.
class M2X::Client::Devices
  # Creates a new M2X Device API Wrapper
  def initialize(client)
    @client = client
  end

  # Search the catalog of public devices. This allows unauthenticated
  # users to search devices from other users that has been marked as
  # public, allowing only to read their metadata, locations, list
  # its streams, view each stream metadata and its values.
  #
  # Refer to the device documentation for the full list of supported parameters
  def catalog(params={})
    @client.get("/devices/catalog", params)
  end

  # List/search all the devices that belong to the user associated
  # with the M2X API key supplied when initializing M2X
  #
  # Refer to the device documentation for the full list of supported parameters
  def list(params={})
    @client.get("/devices", params)
  end
  alias_method :search, :list

  # Create a new device
  #
  # Refer to the device documentation for the full list of supported parameters
  def create(params={})
    @client.post("/devices", nil, params, "Content-Type" => "application/json")
  end

  # Return the details of the supplied device
  def view(id)
    @client.get("/devices/#{URI.encode(id)}")
  end

  # Update an existing device details
  #
  # Refer to the device documentation for the full list of supported parameters
  def update(id, params={})
    @client.put("/devices/#{URI.encode(id)}", nil, params, "Content-Type" => "application/json")
  end

  # Return a list of access log to the supplied device
  def log(id)
    @client.get("/devices/#{URI.encode(id)}/log")
  end

  # Return the current location of the supplied device
  #
  # Note that this method can return an empty value (response status
  # of 204) if the device has no location defined.
  def location(id)
    @client.get("/devices/#{URI.encode(id)}/location")
  end

  # Update the current location of the device
  def update_location(id, params)
    @client.put("/devices/#{URI.encode(id)}/location", nil, params, "Content-Type" => "application/json")
  end

  # Post multiple values to multiple streams
  #
  # This method allows posting multiple values to multiple streams
  # belonging to a device. All the streams should be created before
  # posting values using this method. The `values` parameters is a
  # hash with the following format:
  #
  #    {
  #      "stream-name-1": [
  #        { "at": <Time in ISO8601>, "value": x },
  #        { "at": <Time in ISO8601>, "value": y }
  #      ],
  #      "stream-name-2": [ ... ]
  #    }
  def post_updates(id, values)
    params = { values: values }
    @client.post("/devices/#{URI.encode(id)}/updates", nil, params, "Content-Type" => "application/json")
  end

  # Returns a list of API keys associated with the device
  def keys(id)
    @client.get("/keys", device: id)
  end

  # Creates a new API key associated to the device
  #
  # If a parameter named `stream` is supplied with a stream name, it
  # will create an API key associated with that stream only.
  def create_key(id, params)
    keys_api.create(params.merge(device: id))
  end

  # Updates an API key properties
  def update_key(id, key, params)
    keys_api.update(key, params.merge(device: id))
  end

  private

  def keys_api
    @keys_api ||= ::M2X::Client::Keys.new(@client)
  end
end
