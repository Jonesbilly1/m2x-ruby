# Wrapper for AT&T M2X Distributions API
#
# See https://m2x.att.com/developer/documentation/distributions
class M2X::Client::Distribution
  extend Forwardable

  PATH = "/distributions"

  class << self
    # List/search all the distributions that belong to the user associated
    # with the M2X API key supplied when initializing M2X
    #
    # Refer to the distribution documentation for the full list of supported parameters
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["distributions"].map{ |atts| new(client, atts) } if res.success?
    end
    alias_method :search, :list

    # Create a new distribution
    #
    # Refer to the distribution documentation for the full list of supported parameters
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

  # Return the details of the distribution
  def view
    res = @client.get(path)

    @attributes = res.json if res.success?
  end

  # Update an existing device distribution details
  #
  # Refer to the distribution documentation for the full list of supported parameters
  def update(params)
    @client.put(path, nil, params, "Content-Type" => "application/json")
  end

  # List/search all devices in the distribution
  def devices(params={})
    res = @client.get("#{path}/devices", params)

    res.json["devices"].map{ |atts| ::M2X::Client::Device.new(@client, atts) } if res.success?
  end

  # Add a new device to an existing distribution
  #
  # Accepts a `serial` parameter, that must be a unique identifier
  # within this distribution.
  def add_device(serial)
    res = @client.post("#{path}/devices", nil, { serial: serial }, "Content-Type" => "application/json")

    ::M2X::Client::Device.new(@client, res.json) if res.success?
  end

  # Delete an existing device distribution
  def delete
    @client.delete(path)
  end
end
