require_relative "m2x/client"
require_relative "m2x/keys"
require_relative "m2x/feeds"

class M2X
  VERSION = "0.0.2"

  attr_reader :api_base
  attr_reader :api_key

  def initialize(api_key=nil, api_base=nil)
    @api_base = api_base
    @api_key  = api_key
  end

  def client
    @client ||= ::M2X::Client.new(@api_key, @api_base)
  end

  def status
    client.get("/status")
  end

  def keys
    @keys ||= ::M2X::Keys.new(client)
  end

  def feeds
    @feeds ||= ::M2X::Feeds.new(client)
  end
end
