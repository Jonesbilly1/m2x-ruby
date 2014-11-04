# Wrapper for AT&T M2X Distributions API
#
# See https://m2x.att.com/developer/documentation/device
class M2X::Client::Distributions
  # Creates a new M2X Distributions API Wrapper
  def initialize(client)
    @client = client
  end

  # List/search all the device distributions that belong to the user
  # associated with the M2X API key supplied when initializing M2X
  #
  # The list of device distributions can be filtered by using one or
  # more of the following optional parameters:
  #
  # * `q` text to search, matching the name and description.
  # * `tags` a comma separated list of tags.
  # * `limit` how many results per page.
  # * `page` the specific results page, starting by 1.
  # * `latitude` and `longitude` for searching devices geographically.
  # * `distance` numeric value in `distance_unit`.
  # * `distance_unit` either `miles`, `mi` or `km`.
  def list(params={})
    @client.get("/distributions", params)
  end
  alias_method :search, :list

  # Create a new device distribution
  #
  # Accepts the following parameters as members of a hash:
  #
  # * `name` the name of the new distribution.
  # * `visibility` either "public" or "private".
  # * `description` containing a longer description (optional).
  # * `tags` a comma separated string of tags (optional).
  def create(params={})
    @client.post("/distributions", nil, params, "Content-Type" => "application/json")
  end

  # Retrieve information about an existing device distribution
  def view(id)
    @client.get("/distributions/#{URI.encode(id)}")
  end

  # Update an existing device distribution details
  #
  # Accepts the following parameters as members of a hash:
  #
  # * `name` the name of the distribution.
  # * `visibility` either "public" or "private".
  # * `description` containing a longer description (optional).
  # * `tags` a comma separated string of tags (optional).
  def update(id, params={})
    @client.put("/distributions/#{URI.encode(id)}", nil, params, "Content-Type" => "application/json")
  end

  # List/search all devices in the distribution
  #
  # See Devices#search for search parameters description.
  def devices(id, params={})
    @client.get("/distributions/#{URI.encode(id)}/devices", params)
  end

  # Add a new device to an existing distribution
  #
  # Accepts a `serial` parameter, that must be a unique identifier
  # within this distribution.
  def add_device(id, serial)
    @client.post("/distributions/#{URI.encode(id)}/devices", nil, { serial: serial }, "Content-Type" => "application/json")
  end

  # Delete an existing device distribution
  def delete(id)
    @client.delete("/distributions/#{URI.encode(id)}")
  end
end
