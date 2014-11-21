# Wrapper for AT&T M2X Devices API
#
# See https://m2x.att.com/developer/documentation/device for AT&T M2X
class M2X::Client::Device
  extend Forwardable

  PATH = "/devices"

  class << self
    # List/search all the devices that belong to the user associated
    # with the M2X API key supplied when initializing M2X
    #
    # Refer to the device documentation for the full list of supported parameters
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    # Search the catalog of public devices. This allows unauthenticated
    # users to search devices from other users that has been marked as
    # public, allowing only to read their metadata, locations, list
    # its streams, view each stream metadata and its values.
    #
    # Refer to the device documentation for the full list of supported parameters
    def catalog(client, params={})
      res = client.get("#{PATH}/catalog", params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    # Create a new device
    #
    # Refer to the device documentation for the full list of supported parameters
    def create(client, params)
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  attr_reader :attributes

  def_delegator :@attributes, :[]

  def initialize(client, attributes)
    @client     = client
    @attributes = attributes
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
  end

  # Return the details of the supplied device
  def view
    res = @client.get(path)

    @attributes = res.json if res.success?
  end

  # Update an existing device details
  #
  # Refer to the device documentation for the full list of supported parameters
  def update(params)
    @client.put(path, nil, params, "Content-Type" => "application/json")
  end

  # Return a list of access log to the supplied device
  def log
    @client.get("#{path}/log")
  end

  # Return the current location of the supplied device
  #
  # Note that this method can return an empty value (response status
  # of 204) if the device has no location defined.
  def location
    @client.get("#{path}/location")
  end

  # Update the current location of the device
  def update_location(params)
    @client.put("#{path}/location", nil, params, "Content-Type" => "application/json")
  end

  # Post stream updates
  #
  # This method allows posting multiple values to multiple streams
  # belonging to a device and optionally, the device location.
  #
  # All the streams should be created before posting values using this method.
  #
  # Refer to the Device documentation for details
  def post_updates(params)
    @client.post("#{path}/updates", nil, params, "Content-Type" => "application/json")
  end

  def streams
    ::M2X::Client::Stream.list(@client, self)
  end

  def fetch_stream(name)
    ::M2X::Client::Stream.fetch(@client, self, name)
  end

  def update_stream(name, params={})
    stream = ::M2X::Client::Stream.new(@client, self, "name" => name)

    stream.update(params)
  end
  alias_method :create_stream, :update_stream

  # Returns a list of API keys associated with the device
  def keys
    ::M2X::Client::Key.list(@client, params.merge(device: self["id"]))
  end

  # Creates a new API key associated to the device
  #
  # If a parameter named `stream` is supplied with a stream name, it
  # will create an API key associated with that stream only.
  def create_key(params)
    ::M2X::Client::Key.create(@client, params.merge(device: self["id"]))
  end
end
