require_relative "./resource"
require_relative "./metadata"

# Wrapper for {https://m2x.att.com/developer/documentation/v2/distribution M2X Distribution} API
class M2X::Client::Distribution < M2X::Client::Resource
  include M2X::Client::Metadata

  PATH = "/distributions"

  class << self
    #
    # Method for {https://m2x.att.com/developer/documentation/v2/distribution#List-Distributions List Distributions} endpoint.
    # Retrieve list of device distributions accessible by the authenticated
    # API key.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Distribution} objects
    #
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["distributions"].map{ |atts| new(client, atts) } if res.success?
    end
    alias_method :search, :list

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/distribution#Create-Distribution Create Distribution} endpoint.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return {Distribution} The newly created Distribution.
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
  # Method for {https://m2x.att.com/developer/documentation/v2/distribution#List-Devices-from-an-existing-Distribution List Devices from an existing Distribution} endpoint.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return (Array) List of Device objects
  #
  def devices(params={})
    res = @client.get("#{path}/devices", params)

    res.json["devices"].map{ |atts| ::M2X::Client::Device.new(@client, atts) } if res.success?
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/distribution#Add-Device-to-an-existing-Distribution Add Device to an existing Distribution} endpoint.
  #
  # @param (String) serial The unique (account-wide) serial for the DistributionDevice being added
  # @return {Device} The newly created DistributionDevice
  #
  def add_device(serial)
    res = @client.post("#{path}/devices", nil, { serial: serial }, "Content-Type" => "application/json")

    ::M2X::Client::Device.new(@client, res.json) if res.success?
  end
end
