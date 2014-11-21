# Wrapper for AT&T M2X Keys API
#
# See https://m2x.att.com/developer/documentation/keys for AT&T M2X
class M2X::Client::Key

  PATH = "/keys"

  class << self
    # List all the Master API Key that belongs to the user associated
    # with the AT&T M2X API key supplied when initializing M2X
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["keys"].map{ |atts| new(client, atts) } if res.success?
    end

    # Create a new API Key
    #
    # Note that, according to the parameters sent, you can create a
    # Master API Key or a Device/Stream API Key. See
    # https://m2x.att.com/developer/documentation/keys#Create-Key for
    # details on the parameters accepted by this method.
    def create(client, params={})
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def initialize(client, attributes)
    @client     = client
    @attributes = attributes
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("key")) }"
  end

  # Return the details of the key
  def view
    res = @client.get(path)

    @attributes = res.json if res.success?
  end

  # Update API Key properties
  #
  # This method accepts the same parameters as create API Key and
  # has the same validations. Note that the Key token cannot be
  # updated through this method.
  def update(params)
    @client.put(path, nil, params, "Content-Type" => "application/json")
  end

  # Regenerate an API Key token
  #
  # Note that if you regenerate the key that you're using for
  # authentication then you would need to change your scripts to
  # start using the new key token for all subsequent requests.
  def regenerate
    res = @client.post("#{path}/regenerate", nil, {})

    if res.success?
      @path = nil
      @attributes = res.json
    end
  end

  # Delete the supplied API Key
  def delete
    @client.delete(path)
  end
end
