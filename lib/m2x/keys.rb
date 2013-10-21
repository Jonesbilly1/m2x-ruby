class M2X

  # Wrapper for AT&T M2X Keys API
  #
  # See https://m2x.att.com/developer/documentation/keys for AT&T M2X
  # HTTP Keys API documentation.
  class Keys
    # Creates a new M2X Keys API wrapper
    #
    # See M2X::Client for a description of the client API.
    def initialize(client)
      @client = client
    end

    # List all the Master API Keys that belongs to the user associated
    # with the AT&T M2X API key supplied when initializing M2X
    def list
      @client.get("/keys")
    end

    # Return the details of the API Key supplied
    def view(key)
      @client.get("/keys/#{URI.encode(key.to_s)}")
    end

    # Delete the supplied API Key
    def delete(key)
      @client.delete("/keys/#{URI.encode(key.to_s)}")
    end

    # Create a new API Key
    #
    # Note that, according to the parameters sent, you can create a
    # Master API Key or a Feed/Stream API Key. See
    # https://m2x.att.com/developer/documentation/keys#Create-Key for
    # details on the parameters accepted by this method.
    def create(params)
      @client.post("/keys", nil, params, "Content-Type" => "application/json")
    end

    # Update API Key properties
    #
    # This method accepts the same parameters as create API Key and
    # has the same validations. Note that the Key token cannot be
    # updated through this method.
    def update(key, params)
      @client.put("/keys/#{URI.encode(key.to_s)}", nil, params, "Content-Type" => "application/json")
    end

    # Regenerate an API Key token
    def regenerate(key)
      @client.post("/keys/#{URI.encode(key.to_s)}/regenerate", nil, {})
    end
  end
end
