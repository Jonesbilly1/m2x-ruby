require_relative "m2x/version"
require_relative "m2x/client"
require_relative "m2x/keys"
require_relative "m2x/feeds"

class M2X
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

  def blueprints
    @blueprints ||= ::M2X::Blueprints.new(client)
  end

  def datasources
    @datasources ||= ::M2X::Datasources.new(client)
  end

  def batches
    @batches ||= ::M2X::Batches.new(client)
  end
end
