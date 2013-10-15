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

    def streams(id)
      @client.get("/feeds/#{URI.encode(id)}/streams")
    end

    def stream_values(id, name)
      @client.get("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}/values")
    end

    def stream_put(id, name, params)
      @client.put("/feeds/#{URI.encode(id)}/streams/#{URI.encode(name)}", {}, params)
    end

    def keys(id)
      @client.get("/keys", feed: id)
    end
  end
end
