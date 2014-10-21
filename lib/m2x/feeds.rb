class M2X

  # Wrapper for AT&T M2X Feed API
  #
  # See https://m2x.att.com/developer/documentation/feed for AT&T M2X
  # HTTP Feed API documentation.
  class Feeds
    # Creates a new M2X Feed API Wrapper
    def initialize(client)
      @client = client
    end

    # List/search all the feeds that belong to the user associated
    # with the M2X API key supplied when initializing M2X
    #
    # The list of feeds can be filtered by using one or more of the
    # following optional parameters:
    #
    # * `q` text to search, matching the name and description.
    # * `type` one of `bleuprint`, `batch` and `datasource`.
    # * `tags` a comma separated list of tags.
    # * `limit` how many results per page.
    # * `page` the specific results page, starting by 1.
    # * `latitude` and `longitude` for searching feeds geographically.
    # * `distance` numeric value in `distance_unit`.
    # * `distance_unit` either `miles`, `mi` or `km`.
    def list(params={})
      @client.get("/feeds", params)
    end
    alias_method :search, :list

    # Return the details of the supplied feed
    def view(id)
      @client.get("/feeds/#{URI.encode(id)}")
    end

    # Return a list of access log to the supplied feed
    def log(id)
      @client.get("/feeds/#{URI.encode(id)}/log")
    end

    # Return the current location of the supplied feed
    #
    # Note that this method can return an empty value (response status
    # of 204) if the feed has no location defined.
    def location(id)
      @client.get("/feeds/#{URI.encode(id)}/location")
    end

    # Update the current location of the feed
    def update_location(id, params)
      @client.put("/feeds/#{URI.encode(id)}/location", nil, params)
    end

    # Return a list of the associated streams for the supplied feed
    def streams(id)
      @client.get("/feeds/#{URI.encode(id)}/streams")
    end

    # Return the details of the supplied stream
    def stream(id, name)
      @client.get("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}")
    end

    # Update stream's properties
    #
    # If the stream doesn't exist it will create it. See
    # https://m2x.att.com/developer/documentation/feed#Create-Update-Data-Stream
    # for details.
    def update_stream(id, name, params={})
      @client.put("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}", {}, params)
    end

    # Delete the stream (and all its values) from the feed
    def delete_stream(id, name)
      @client.delete("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}")
    end

    # List values from an existing data stream associated with a
    # specific feed, sorted in reverse chronological order (most
    # recent values first).
    #
    # The values can be filtered by using one or more of the following
    # optional parameters:
    #
    # * `start` An ISO 8601 timestamp specifying the start of the date
    # * range to be considered.
    #
    # * `end` An ISO 8601 timestamp specifying the end of the date
    # * range to be considered.
    #
    # * `limit` Maximum number of values to return.
    def stream_values(id, name, params={})
      @client.get("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}/values", params)
    end

    # Post multiple values to multiple streams
    #
    # This method allows posting multiple values to multiple streams
    # belonging to a feed. All the streams should be created before
    # posting values using this method. The `values` parameters is a
    # hash with the following format:
    #
    #    {
    #      "stream-name-1": [
    #        { "at": <Time in ISO8601>, "value": x },
    #        { "value": y }
    #      ],
    #      "stream-name-2": [ ... ]
    #    }
    #
    # If the `at` attribute is missing the the current time of the
    # server, in UTC, will be used.
    def post_multiple(id, values)
      params = { values: values }
      @client.post("/feeds/#{URI.encode(id)}", nil, params, "Content-Type" => "application/json")
    end

    # Returns a list of API keys associated with the feed
    def keys(id)
      @client.get("/keys", feed: id)
    end

    # Creates a new API key associated to the feed
    #
    # If a parameter named `stream` is supplied with a stream name, it
    # will create an API key associated with that stream only.
    def create_key(id, params)
      keys_api.create(params.merge(feed: id))
    end

    # Updates an API key properties
    def update_key(id, key, params)
      keys_api.update(key, params.merge(feed: id))
    end

    private

    def keys_api
      @keys_api ||= ::M2X::Keys.new(@client)
    end
  end
end
