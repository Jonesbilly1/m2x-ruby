require_relative "./resource"

# Wrapper for AT&T M2X Distribution API
# https://m2x.att.com/developer/documentation/v2/distribution
class M2X::Client::Distribution < M2X::Client::Resource

  PATH = "/distributions"

  class << self
    # Retrieve list of device distributions accessible by the authenticated
    # API key.
    #
    # https://m2x.att.com/developer/documentation/v2/distribution#List-Distributions
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["distributions"].map{ |atts| new(client, atts) } if res.success?
    end
    alias_method :search, :list

    # Create a new device distribution
    #
    # https://m2x.att.com/developer/documentation/v2/distribution#Create-Distribution
    def create!(client, params)
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
  end

  # Retrieve list of devices added to the specified distribution.
  #
  # https://m2x.att.com/developer/documentation/v2/distribution#List-Devices-from-an-existing-Distribution
  def devices(params={})
    res = @client.get("#{path}/devices", params)

    res.json["devices"].map{ |atts| ::M2X::Client::Device.new(@client, atts) } if res.success?
  end

  # Add a new device to an existing distribution
  #
  # Accepts a `serial` parameter, that must be a unique identifier
  # within this distribution.
  #
  # https://m2x.att.com/developer/documentation/v2/distribution#Add-Device-to-an-existing-Distribution
  def add_device(serial)
    res = @client.post("#{path}/devices", nil, { serial: serial }, "Content-Type" => "application/json")

    ::M2X::Client::Device.new(@client, res.json) if res.success?
  end
end
