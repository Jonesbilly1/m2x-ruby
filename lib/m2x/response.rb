# Response wrapper for M2X client
class M2X::Client::Response
  attr_reader :response

  def initialize(response)
    @response = response
  end

  def raw
    @response.body
  end

  def json
    @json ||= ::JSON.parse(raw)
  end

  def status
    @status ||= @response.code.to_i
  end

  def headers
    @headers ||= @response.to_hash
  end

  def success?
    (200..299).include?(status)
  end

  def client_error?
    (400..499).include?(status)
  end

  def server_error?
    (500..599).include?(status)
  end

  def error?
    client_error? || server_error?
  end
end
