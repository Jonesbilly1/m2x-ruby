require_relative "./resource"
require_relative "./metadata"

# Wrapper for {https://m2x.att.com/developer/documentation/v2/collections M2X Collections} API
class M2X::Client::Collection < M2X::Client::Resource
  include M2X::Client::Metadata

  PATH = "/collections"

  class << self
    #
    # Method for {https://m2x.att.com/developer/documentation/v2/collections#List-collections List Collections} endpoint.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Collection} objects
    #
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["collections"].map{ |atts| new(client, atts) } if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/collections#Create-Collection Create Collection} endpoint.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return {Collection} The newly created Collection.
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
  # Method for {https://m2x.att.com/developer/documentation/v2/collections#List-Devices-from-an-existing-Collection List Devices from an existing collection} endpoint.
  #
  # @return (Array) List of Device objects
  #
  def devices
    res = @client.get("#{path}/devices")

    res.json["devices"].map{ |atts| M2X::Client::Device.new(@client, atts) } if res.success?
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/collections#Add-device-to-collection Add a device to the collection} endpoint.
  #
  # @param (String) device_id ID of the Device being added to Collection
  # @return {Response} The API response, see M2X API docs for details
  #
  def add_device(device_id)
    @client.put("#{ path }/devices/#{ device_id }")
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/collections#Remove-device-from-collection Remove a device from the collection} endpoint.
  #
  # @param (String) device_id ID of the Device being removed from Collection
  # @return {Response} The API response, see M2X API docs for details
  #
  def remove_device(device_id)
    @client.delete("#{ path }/devices/#{ device_id }")
  end
end
