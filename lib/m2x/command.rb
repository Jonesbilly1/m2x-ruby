# Wrapper for AT&T M2X Commands API
# https://m2x.att.com/developer/documentation/v2/commands
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

  # View Command Details
  #
  # Get details of a sent command including the delivery information for all
  # devices that were targetted by the command at the time it was sent.
  #
  # https://m2x.att.com/developer/documentation/v2/commands#View-Command-Details
  def view
    res = @client.get(path)

    @attributes = res.json if res.success?
  end

  def inspect
    "<#{self.class.name}: #{attributes.inspect}>"
  end

  class << self
    # List Sent Commands
    #
    # Retrieve the list of recent commands sent by the current user
    # (as given by the API key).
    #
    # https://m2x.att.com/developer/documentation/v2/commands#List-Sent-Commands
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["commands"].map { |atts| new(client, atts) } if res.success?
    end

    # Send Command
    #
    # Send a command with the given name to the given target devices.
    # The name should be a custom string defined by the user and understood by
    # the device.
    #
    # https://m2x.att.com/developer/documentation/v2/commands#Send-Command
    def send!(client, params)
      client.post(PATH, nil, params, "Content-Type" => "application/json")
    end
  end
end
