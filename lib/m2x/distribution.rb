# Wrapper for AT&T M2X Distribution API
# https://m2x.att.com/developer/documentation/v2/distribution
class M2X::Client::Distribution < M2X::Client::Resource

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
    def create!(client, params)
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
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
end
