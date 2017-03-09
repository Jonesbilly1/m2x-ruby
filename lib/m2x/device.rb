require_relative "./resource"
require_relative "./metadata"

# Wrapper for {https://m2x.att.com/developer/documentation/v2/device M2X Device} API
class M2X::Client::Device < M2X::Client::Resource
  include M2X::Client::Metadata

  PATH = "/devices"

  class << self
    #
    # Method for {https://m2x.att.com/developer/documentation/v2/device#List-Devices List Devices} endpoint.
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Device} objects
    #
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/device#Search-Devices Search Devices} endpoint.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Device} objects.
    #
    def search(client, params={})
      res = client.get("#{PATH}/search", params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/device#List-Search-Public-Devices-Catalog List Search Public Devices Catalog} endpoint.
    # This allows unauthenticated users to search Devices from other users
    # that have been marked as public, allowing them to read public Device
    # metadata, locations, streams list, and view each Devices' stream metadata
    # and its values.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Device} objects.
    #
    def catalog(client, params={})
      res = client.get("#{PATH}/catalog", params)

      res.json["devices"].map{ |atts| new(client, atts) } if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/device#List-Device-Tags List Device Tags} endpoint.
    #
    # @param {Client} client Client API
    # @return (Array) Device Tags associated with the account
    #
    def tags(client)
      client.get("#{PATH}/tags")
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/device#Create-Device Create Device} endpoint.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return {Device} newly created device.
    #
    def create!(client, params)
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#View-Request-Log View Request Log} endpoint.
  # Retrieve list of HTTP requests received lately by the specified device
  # (up to 100 entries).
  #
  # @return (Array) Most recent API requests made against this Device
  #
  def log
    @client.get("#{path}/log")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Read-Device-Location Read Device Location} endpoint.
  # Note that this method can return an empty value (response status
  # of 204) if the device has no location defined.
  #
  # @return {Response} Most recently logged location of the Device, see M2X API docs for details
  #
  def location
    @client.get("#{path}/location")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Read-Device-Location-History Read Device Location History} endpoint.
  # Returns the 30 most recently logged locations by default.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) Location history of the Device
  #
  def location_history(params = {})
    @client.get("#{path}/location/waypoints", params)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Update-Device-Location Update Device Location} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} The API response, see M2X API docs for details.
  #
  def update_location(params)
    @client.put("#{path}/location", nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Delete-Location-History Delete Location History} endpoint.
  # The `start` and `stop` parameters should be ISO8601 timestamps
  #
  # @param (String) start from time to delete the location history
  # @param (String) stop end time to delete the location history
  # @return {Response} The API response, see M2X API docs for details.
  #
  def delete_locations!(start, stop)
    params = { from: start, end: stop }

    @client.delete("#{path}/location/waypoints", nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Post-Device-Updates--Multiple-Values-to-Multiple-Streams- Post Device Updates (Multiple Values to Multiple Streams)} endpoint.
  # All the streams should be created before posting values using this method.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} the API response, see M2X API docs for details
  #
  def post_updates(params)
    @client.post("#{path}/updates", nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Post-Device-Update--Single-Values-to-Multiple-Streams- Post Device Update (Single Value to Multiple Streams)} endpoint.
  # All the streams should be created before posting values using this method.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} the API response, see M2X API docs for details
  #
  def post_update(params)
    @client.post("#{path}/update", nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#List-Values-from-all-Data-Streams-of-a-Device List Values from all Data Streams} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) List of values from all the streams.
  #
  def values(params = {})
    @client.get("#{path}/values", params)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Export-Values-from-all-Data-Streams-of-a-Device Export Values from all Data Streams of a Device} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} the API response, see M2X API docs for details
  #
  def values_export(params = {})
    @client.get("#{path}/values/export.csv", params)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Search-Values-from-all-Data-Streams-of-a-Device Search Values from all Data Streams of a Device} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) List of values matching the search criteria.
  #
  def values_search(params)
    @client.get("#{path}/values/search", nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#List-Data-Streams List Data Streams} endpoint.
  #
  # @return (Array) List of {Stream} objects.
  #
  def streams
    ::M2X::Client::Stream.list(@client, self)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#View-Data-Stream View Data Stream} endpoint.
  #
  # @param (String) name name of the stream to be fetched
  # @return {Stream} The matching stream
  #
  def stream(name)
    ::M2X::Client::Stream.fetch(@client, self, name)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/device#Create-Update-Data-Stream Create Update Data Stream} endpoint.
  # (if a stream with this name does not exist it gets created).
  #
  # @param (String) name Name of the stream to be updated
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Stream} The Stream being updated
  #
  def update_stream(name, params={})
    stream = ::M2X::Client::Stream.new(@client, self, "name" => name)

    stream.update!(params)
  end
  alias_method :create_stream, :update_stream

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/keys#List-Keys List Keys} endpoint.
  #
  # @return (Array) List of {Key} objects.
  #
  def keys
    ::M2X::Client::Key.list(@client, params.merge(device: self["id"]))
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/keys#Create-Key Create Key} endpoint.
  # Note that, according to the parameters sent, you can create a
  # Master API Key or a Device/Stream API Key.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Key} The newly created Key.
  #
  def create_key(params)
    ::M2X::Client::Key.create!(@client, params.merge(device: self["id"]))
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/commands#Device-s-List-of-Received-Commands Device's List of Recieved Commands} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) List of {Command} objects.
  #
  def commands(params = {})
    res = @client.get("#{path}/commands", params)

    res.json["commands"].map { |atts| M2X::Client::Command.new(@client, atts) } if res.success?
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/commands#Device-s-View-of-Command-Details Device's View of Command Details} endpoint.
  # Get details of a received command including the delivery information for this device.
  #
  # @param (String) id Command ID to get
  # @return {Command} object retrieved
  #
  def command(id)
    res = @client.get("#{path}/commands/#{id}")

    M2X::Client::Command.new(@client, res.json) if res.success?
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/commands#Device-Marks-a-Command-as-Processed Process Command} endpoint.
  #
  # @param (String) id Command ID to process
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} The API response, see M2X API docs for details
  #
  def process_command(id, params = {})
    @client.post("#{path}/commands/#{id}/process", nil, params)
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/commands#Device-Marks-a-Command-as-Rejected Reject Command} endpoint.
  #
  # @param (String) id Command ID to process
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} The API response, see M2X API docs for details
  #
  def reject_command(id, params = {})
    @client.post("#{path}/commands/#{id}/reject", nil, params)
  end
end
