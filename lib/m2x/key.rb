# Wrapper for AT&T M2X Keys API
#
# See https://m2x.att.com/developer/documentation/keys for AT&T M2X
# HTTP Key API documentation.
class M2X::Client::Key

  PATH = "/keys"

  class << self
    def client
      @client ||= M2X::Client
    end

    # Return the details of the supplied key
    def [](key)
      res = client.get("#{PATH}/#{URI.encode(key.to_s)}")
      if res.success?
        json = res.json

        new(json["key"], json)
      end
    end

    # List all the Master API Key that belongs to the user associated
    # with the AT&T M2X API key supplied when initializing M2X
    def list
      res = client.get("#{PATH}")

      res.json["keys"].map{ |atts| new(atts["key"], atts) } if res.success?
    end

    # Create a new API Key
    #
    # Note that, according to the parameters sent, you can create a
    # Master API Key or a Device/Stream API Key. See
    # https://m2x.att.com/developer/documentation/keys#Create-Key for
    # details on the parameters accepted by this method.
    def create(params={})
      client.post("#{PATH}", nil, params, "Content-Type" => "application/json")
    end
  end

  def client
    self.class.client
  end

  attr_accessor :key
  attr_accessor :attributes

  def initialize(key, attributes)
    @key = key
    @attributes = attributes
  end

  def base_path
    @base_path ||= "#{PATH}/#{URI.encode(@key.to_s)}"
  end

  # Update API Key properties
  #
  # This method accepts the same parameters as create API Key and
  # has the same validations. Note that the Key token cannot be
  # updated through this method.
  def update(params)
    client.put("#{base_path}", nil, params, "Content-Type" => "application/json")
  end

  # Regenerate an API Key token
  #
  # Note that if you regenerate the key that you're using for
  # authentication then you would need to change your scripts to
  # start using the new key token for all subsequent requests.
  def regenerate
    res = client.post("#{base_path}/regenerate", nil, {})

    if res.success?
      @base_path = nil
      @key       = res.json["key"]

      @attributes["key"] = @key
    end
  end

  # Delete the supplied API Key
  def delete
    client.delete(base_path)
  end
end
