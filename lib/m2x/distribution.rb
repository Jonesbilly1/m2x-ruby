# Wrapper for AT&T M2X Distributions API
#
# See https://m2x.att.com/developer/documentation/distributions
class M2X::Client::Distribution

  PATH = "/distributions"

  class << self
    def client
      @client ||= M2X::Client
    end

    # Return the details of the supplied distribution
    def [](id)
      res = client.get("#{PATH}/#{URI.encode(id)}")
      if res.success?
        json = res.json

        new(json["id"], json)
      end
    end

    # List/search all the distributions that belong to the user associated
    # with the M2X API key supplied when initializing M2X
    #
    # Refer to the distribution documentation for the full list of supported parameters
    def list(params={})
      res = client.get("#{PATH}", params)

      res.json["distributions"].map{ |atts| new(atts["id"], atts) } if res.success?
    end
    alias_method :search, :list

    # Create a new distribution
    #
    # Refer to the distribution documentation for the full list of supported parameters
    def create(params={})
      client.post("#{PATH}", nil, params, "Content-Type" => "application/json")
    end
  end

  def client
    self.class.client
  end

  attr_accessor :id
  attr_accessor :attributes

  def initialize(id, attributes)
    @id = id
    @attributes = attributes
  end

  def base_path
    @base_path ||= "#{PATH}/#{URI.encode(@id)}"
  end

  # Update an existing device distribution details
  def update(params={})
    client.put("#{base_path}", nil, params, "Content-Type" => "application/json")
  end

  # List/search all devices in the distribution
  #
  # See Device#search for search parameters description.
  def devices(params={})
    res = client.get("#{base_path}/devices", params)

    res.json["devices"].map{ |atts| ::M2X::Client::Device.new(atts["id"], atts) } if res.success?
  end

  # Add a new device to an existing distribution
  #
  # Accepts a `serial` parameter, that must be a unique identifier
  # within this distribution.
  def add_device(serial)
    client.post("#{base_path}/devices", nil, { serial: serial }, "Content-Type" => "application/json")
  end

  # Delete an existing device distribution
  def delete
    client.delete("#{base_path}")
  end
end
