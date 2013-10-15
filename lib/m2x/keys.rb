class M2X
  class Keys
    def initialize(client)
      @client = client
    end

    def list
      @client.get("/keys")
    end

    def view(id)
      @client.get("/keys/#{URI.encode(id.to_s)}")
    end

    def delete(id)
      @client.delete("/keys/#{URI.encode(id.to_s)}")
    end

    def create(params)
      @client.post("/keys", nil, params, "Content-Type" => "application/json")
    end

    def update(id, params)
      @client.put("/keys/#{URI.encode(id.to_s)}", nil, params, "Content-Type" => "application/json")
    end

    def regenerate(id)
      @client.post("/keys/#{URI.encode(id.to_s)}/regenerate", nil, {})
    end
  end
end
