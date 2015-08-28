# Wrapper for AT&T M2X Device API
# https://m2x.att.com/developer/documentation/v2/device
class M2X::Client::Device < M2X::Client::Resource

  PATH = "/devices"

  class << self
    # Retrieve the list of devices accessible by the authenticated API key
    #
    # https://m2x.att.com/developer/documentation/v2/device#List-Devices
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    # Retrieve the list of devices accessible by the authenticated API key that
    # meet the search criteria.
    #
    # https://m2x.att.com/developer/documentation/v2/device#Search-Devices
    def search(client, params={})
      res = client.get("#{PATH}/search", params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    # Search the catalog of public Devices.
    #
    # This allows unauthenticated users to search Devices from other users
    # that have been marked as public, allowing them to read public Device
    # metadata, locations, streams list, and view each Devices' stream metadata
    # and its values.
    #
    # https://m2x.att.com/developer/documentation/v2/device#List-Search-Public-Devices-Catalog
    def catalog(client, params={})
      res = client.get("#{PATH}/catalog", params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    # List Device Tags
    # Retrieve the list of device tags for the authenticated user.
    #
    # https://m2x.att.com/developer/documentation/v2/device#List-Device-Tags
    def tags(client)
      client.get("#{PATH}/tags")
    end

    # Create a new device
    #
    # https://m2x.att.com/developer/documentation/v2/device#Create-Device
    def create!(client, params)
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
  end

  # View Request Log
  # Retrieve list of HTTP requests received lately by the specified device
  # (up to 100 entries).
  #
  # https://m2x.att.com/developer/documentation/v2/device#View-Request-Log
  def log
    @client.get("#{path}/log")
  end

  # Get location details of an existing Device.
  #
  # Note that this method can return an empty value (response status
  # of 204) if the device has no location defined.
  #
  # https://m2x.att.com/developer/documentation/v2/device#Read-Device-Location
  def location
    @client.get("#{path}/location")
  end

  # Update the current location of the specified device.
  #
  # https://m2x.att.com/developer/documentation/v2/device#Update-Device-Location
  def update_location(params)
    @client.put("#{path}/location", nil, params, "Content-Type" => "application/json")
  end

  # Post Device Updates (Multiple Values to Multiple Streams)
  #
  # This method allows posting multiple values to multiple streams
  # belonging to a device and optionally, the device location.
  #
  # All the streams should be created before posting values using this method.
  #
  # The `values` parameter contains an object with one attribute per each stream to be updated.
  # The value of each one of these attributes is an array of timestamped values.
  #
  #      {
  #         temperature: [
  #                        { "timestamp": <Time in ISO8601>, "value": x },
  #                        { "timestamp": <Time in ISO8601>, "value": y },
  #                      ],
  #         humidity:    [
  #                        { "timestamp": <Time in ISO8601>, "value": x },
  #                        { "timestamp": <Time in ISO8601>, "value": y },
  #                      ]
  #
  #      }
  #
  # The optional location attribute can contain location information that will
  # be used to update the current location of the specified device
  #
  # https://m2x.att.com/developer/documentation/v2/device#Post-Device-Updates--Multiple-Values-to-Multiple-Streams-
  def post_updates(params)
    @client.post("#{path}/updates", nil, params, "Content-Type" => "application/json")
  end

  # Post Device Update (Single Value to Multiple Streams)
  #
  # This method allows posting a single value to multiple streams
  # belonging to a device and optionally, the device's location.
  #
  # All the streams should be created before posting values using this method.
  #
  # The `params` parameter accepts a Hash which can contain the following keys:
  #   - values:    A Hash in which the keys are the stream names and the values
  #                hold the stream values.
  #   - location:  (optional) A hash with the current location of the specified
  #                device.
  #   - timestamp: (optional) The timestamp for all the passed values and
  #                location. If ommited, the M2X server's time will be used.
  #
  #      {
  #         values: {
  #             temperature: 30,
  #             humidity:    80
  #         },
  #         location: {
  #           name:      "Storage Room",
  #           latitude:  -37.9788423562422,
  #           longitude: -57.5478776916862,
  #           elevation: 5
  #         }
  #      }
  #
  # https://m2x.att.com/developer/documentation/v2/device#Post-Device-Update--Single-Values-to-Multiple-Streams-
  def post_update(params)
    @client.post("#{path}/update", nil, params, "Content-Type" => "application/json")
  end

  # List Values from all Data Streams of a Device
  #
  # https://m2x.att.com/developer/documentation/v2/device#List-Values-from-all-Data-Streams-of-a-Device
  def values(params = {})
    @client.get("#{path}/values", params)
  end

  # Export Values from all Data Streams of a Device
  #
  # https://m2x.att.com/developer/documentation/v2/device#Export-Values-from-all-Data-Streams-of-a-Device
  def values_export(params = {})
    @client.get("#{path}/values/export.csv", params)
  end

  # Search Values from all Data Streams of a Device
  #
  # https://m2x.att.com/developer/documentation/v2/device#Search-Values-from-all-Data-Streams-of-a-Device
  def values_search(params)
    @client.get("#{path}/values/search", nil, params, "Content-Type" => "application/json")
  end

  # Retrieve list of data streams associated with the device.
  #
  # https://m2x.att.com/developer/documentation/v2/device#List-Data-Streams
  def streams
    ::M2X::Client::Stream.list(@client, self)
  end

  # Get details of a specific data Stream associated with the device
  #
  # https://m2x.att.com/developer/documentation/v2/device#View-Data-Stream
  def stream(name)
    ::M2X::Client::Stream.fetch(@client, self, name)
  end

  # Update a data stream associated with the Device
  # (if a stream with this name does not exist it gets created).
  #
  # https://m2x.att.com/developer/documentation/v2/device#Create-Update-Data-Stream
  def update_stream(name, params={})
    stream = ::M2X::Client::Stream.new(@client, self, "name" => name)

    stream.update!(params)
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
    ::M2X::Client::Key.create!(@client, params.merge(device: self["id"]))
  end
end
