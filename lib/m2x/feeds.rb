class M2X
  class Feeds
    def initialize(client)
      @client = client
    end

    def list
      @client.get("/feeds")
    end

    def view(id)
      @client.get("/feeds/#{URI.encode(id)}")
    end

    def log(id)
      @client.get("/feeds/#{URI.encode(id)}/log")
    end

    def location(id)
      @client.get("/feeds/#{URI.encode(id)}/location")
    end

    def location_update(id, params)
      @client.put("/feeds/#{URI.encode(id)}/location", nil, params)
    end

    def location_delete(id)
      @client.delete("/feeds/#{URI.encode(id)}/location")
    end

    def streams(id)
      @client.get("/feeds/#{URI.encode(id)}/streams")
    end

    def stream_values(id, name)
      @client.get("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}/values")
    end

    def stream_put(id, name, params)
      @client.put("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}", {}, params)
    end

    def stream_delete(id, name)
      @client.delete("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}")
    end

    def keys(id)
      @client.get("/keys", feed: id)
    end

    def create_key(id, params)
      keys_api.create(params.merge(feed: id))
    end

    private

    def keys_api
      @keys_api ||= ::M2X::Keys.new(@client)
    end
  end
end
