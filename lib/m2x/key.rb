require_relative "./resource"

# Wrapper for {https://m2x.att.com/developer/documentation/v2/keys M2X Keys} API
class M2X::Client::Key < M2X::Client::Resource

  PATH = "/keys"

  class << self
    #
    # Method for {https://m2x.att.com/developer/documentation/v2/keys#List-Keys List Keys} endpoint.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Key} objects.
    #
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["keys"].map{ |atts| new(client, atts) } if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/keys#Create-Key Create Key} endpoint.
    # Note that, according to the parameters sent, you can create a
    # Master API Key or a Device/Stream API Key.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return {Key} The newly created Key.
    #
    def create!(client, params={})
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("key")) }"
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/keys#Regenerate-Key Regenerate Key} endpoint.
  # Note that if you regenerate the key that you're using for
  # authentication then you would need to change your scripts to
  # start using the new key token for all subsequent requests.
  #
  # @return {Key} The regenerated key.
  #
  def regenerate
    res = @client.post("#{path}/regenerate", nil, {})

    if res.success?
      @path = nil
      @attributes = res.json
    end
  end
end
