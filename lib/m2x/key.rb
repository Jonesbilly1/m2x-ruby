# Wrapper for AT&T M2X Keys API
# https://m2x.att.com/developer/documentation/v2/keys
class M2X::Client::Key < M2X::Client::Resource

  PATH = "/keys"

  class << self
    # Retrieve list of keys associated with the user account.
    #
    # https://m2x.att.com/developer/documentation/v2/keys#List-Keys
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["keys"].map{ |atts| new(client, atts) } if res.success?
    end

    # Create a new API Key
    #
    # Note that, according to the parameters sent, you can create a
    # Master API Key or a Device/Stream API Key.
    #
    # https://m2x.att.com/developer/documentation/v2/keys#Create-Key
    def create!(client, params={})
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("key")) }"
  end

  # Regenerate an API Key token
  #
  # Note that if you regenerate the key that you're using for
  # authentication then you would need to change your scripts to
  # start using the new key token for all subsequent requests.
  #
  # https://m2x.att.com/developer/documentation/v2/keys#Regenerate-Key
  def regenerate
    res = @client.post("#{path}/regenerate", nil, {})

    if res.success?
      @path = nil
      @attributes = res.json
    end
  end
end
