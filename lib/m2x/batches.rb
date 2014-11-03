# Wrapper for AT&T M2X Batches API
#
# See https://m2x.att.com/developer/documentation/device
class M2X::Batches
  # Creates a new M2X Batches API Wrapper
  def initialize(client)
    @client = client
  end

  # List/search all the device batches that belong to the user
  # associated with the M2X API key supplied when initializing M2X
  #
  # The list of device batches can be filtered by using one or
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
    @client.get("/batches", params)
  end
  alias_method :search, :list

  # Create a new device batch
  #
  # Accepts the following parameters as members of a hash:
  #
  # * `name` the name of the new data source.
  # * `visibility` either "public" or "private".
  # * `description` containing a longer description (optional).
  # * `tags` a comma separated string of tags (optional).
  def create(params={})
    @client.post("/batches", nil, params)
  end

  # Retrieve information about an existing device batch
  def view(id)
    @client.get("/batches/#{URI.encode(id)}")
  end

  # Update an existing device batch details
  #
  # Accepts the following parameters as members of a hash:
  #
  # * `name` the name of the new data source.
  # * `visibility` either "public" or "private".
  # * `description` containing a longer description (optional).
  # * `tags` a comma separated string of tags (optional).
  def update(id, params={})
    @client.put("/batches/#{URI.encode(id)}", nil, params)
  end

  # List/search all data sources in the batch
  #
  # See Devices#search for search parameters description.
  def devices(id, params={})
    @client.get("/batches/#{URI.encode(id)}/devices", params)
  end

  # Add a new device to an existing batch
  #
  # Accepts a `serial` parameter, that must be a unique identifier
  # within this batch.
  def add_device(id, serial)
    @client.post("/batches/#{URI.encode(id)}/devices", nil, { serial: serial })
  end

  # Delete an existing device batch
  def delete(id)
    @client.delete("/batches/#{URI.encode(id)}")
  end
end
