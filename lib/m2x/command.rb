# Wrapper for {https://m2x.att.com/developer/documentation/v2/commands M2X Commands} API
class M2X::Client::Command
  extend Forwardable

  PATH = "/commands"

  attr_reader :attributes

  def_delegator :@attributes, :[]

  def initialize(client, attributes)
    @client     = client
    @attributes = attributes
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
  end

  #
  # Method for {https://m2x.att.com/developer/documentation/v2/commands#View-Command-Details View Command Details} endpoint.
  # Get details of a sent command including the delivery information for all
  # devices that were targetted by the command at the time it was sent.
  #
  # @return {Command} The retrieved Command
  #
  def view
    res = @client.get(path)

    @attributes = res.json if res.success?
  end

  def inspect
    "<#{self.class.name}: #{attributes.inspect}>"
  end

  class << self
    #
    # Method for {https://m2x.att.com/developer/documentation/v2/commands#List-Sent-Commands List Sent Commands} endpoint.
    # Retrieve the list of recent commands sent by the current user
    # (as given by the API key).
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Command} objects
    #
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["commands"].map { |atts| new(client, atts) } if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/commands#Send-Command Send Command} endpoint.
    # Send a command with the given name to the given target devices.
    # The name should be a custom string defined by the user and understood by
    # the device.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return {Command} The Command that was just sent.
    #
    def send!(client, params)
      client.post(PATH, nil, params, "Content-Type" => "application/json")
    end
  end
end
