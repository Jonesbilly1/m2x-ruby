require_relative "./resource"
require_relative "./metadata"

# Wrapper for AT&T M2X Collections API
# https://m2x.att.com/developer/documentation/v2/collections
class M2X::Client::Collection < M2X::Client::Resource
  include M2X::Client::Metadata

  PATH = "/collections"

  class << self
    # Retrieve the list of collections accessible by the authenticated API key
    #
    # https://m2x.att.com/developer/documentation/v2/collections#List-collections
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["collections"].map{ |atts| new(client, atts) } if res.success?
    end

    # Create a new collection
    #
    # https://m2x.att.com/developer/documentation/v2/collections#Create-Collection
    def create!(client, params)
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end

    # Add device to collection
    #
    # https://m2x.att.com/developer/documentation/v2/collections#Add-device-to-collection
    def add_device(client, id, device_id, params)
      return client.put("#{PATH}/#{id}/devices/#{device_id}", nil, params, "Content-Type" => "application/json")
    end

    # Remove device from collection
    #
    # https://m2x.att.com/developer/documentation/v2/collections#Remove-device-from-collection
    def remove_device(client, id, device_id, params)
      return client.delete("#{PATH}/#{id}/devices/#{device_id}", nil, params, "Content-Type" => "application/json")
    end

  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
  end
end
