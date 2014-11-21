require "forwardable"

# Wrapper for M2X::Client resources
class M2X::Client::Resource
  extend Forwardable

  attr_reader :attributes

  def_delegator :@attributes, :[]

  def inspect
    "<#{self.class.name}: #{attributes.inspect}>"
  end
end
