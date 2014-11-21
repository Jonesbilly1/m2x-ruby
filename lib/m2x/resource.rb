require "forwardable"

# Wrapper for M2X::Client resources
class M2X::Client::Resource
  extend Forwardable

  attr_reader :attributes

  def_delegator :@attributes, :[]

  def initialize(client, attributes)
    @client     = client
    @attributes = attributes
  end

  # Return the resource details
  def view
    res = @client.get(path)

    @attributes = res.json if res.success?
  end

  # Update an existing resource details
  def update!(params)
    @client.put(path, nil, params, "Content-Type" => "application/json")
  end

  # Delete the resource
  def delete!
    @client.delete(path)
  end

  def inspect
    "<#{self.class.name}: #{attributes.inspect}>"
  end

  def path
    raise NotImplementedError
  end
end
