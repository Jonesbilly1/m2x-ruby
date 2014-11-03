# Wrapper for AT&T M2X Data Sources API
#
# See https://m2x.att.com/developer/documentation/datasource
class M2X::Datasources
  # Creates a new M2X Data Sources API Wrapper
  def initialize(client)
    @client = client
  end

  # List/search all the datasources that belong to the user associated
  # with the M2X API key supplied when initializing M2X
  #
  # The list of data sources can be filtered by using one or more of the
  # following optional parameters:
  #
  # * `q` text to search, matching the name and description.
  # * `tags` a comma separated list of tags.
  # * `limit` how many results per page.
  # * `page` the specific results page, starting by 1.
  # * `latitude` and `longitude` for searching feeds geographically.
  # * `distance` numeric value in `distance_unit`.
  # * `distance_unit` either `miles`, `mi` or `km`.
  def list(params={})
    @client.get("/datasources", params)
  end
  alias_method :search, :list

  # Create a new data source
  #
  # Accepts the following parameters as members of a hash:
  #
  # * `name` the name of the new data source.
  # * `visibility` either "public" or "private".
  # * `description` containing a longer description (optional).
  # * `tags` a comma separated string of tags (optional).
  def create(params={})
    @client.post("/datasources", nil, params)
  end

  # Retrieve information about an existing data source
  def view(id)
    @client.get("/datasources/#{URI.encode(id)}")
  end

  # Update an existing data source details
  #
  # Accepts the following parameters as members of a hash:
  #
  # * `name` the name of the new data source.
  # * `visibility` either "public" or "private".
  # * `description` containing a longer description (optional).
  # * `tags` a comma separated string of tags (optional).
  def update(id, params={})
    @client.put("/datasources/#{URI.encode(id)}", nil, params)
  end

  # Delete an existing data source
  def delete(id)
    @client.delete("/datasources/#{URI.encode(id)}")
  end
end
