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

    def update_location(id, params)
      @client.put("/feeds/#{URI.encode(id)}/location", nil, params)
    end

    def delete_location(id)
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

    def delete_stream(id, name)
      @client.delete("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}")
    end

    def keys(id)
      @client.get("/keys", feed: id)
    end

    def create_key(id, params)
      keys_api.create(params.merge(feed: id))
    end

    def update_key(id, key, params)
      keys_api.update(key, params.merge(feed: id))
    end

    private

    def keys_api
      @keys_api ||= ::M2X::Keys.new(@client)
    end
  end
end
