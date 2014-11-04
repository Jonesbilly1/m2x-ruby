require "net/http"
require "json"
require "openssl"

module M2X::Client
  API_BASE = "https://api-m2x.att.com/v2".freeze

  CA_FILE = File.expand_path("../cacert.pem", __FILE__)

  USER_AGENT = "M2X/#{::M2X::Client::VERSION} (Ruby #{RUBY_VERSION}; #{RUBY_PLATFORM})".freeze

  module_function

  def api_base
    @api_base ||= API_BASE
  end

  def api_base=(api_base)
    @api_base = api_base
  end

  def api_key
    @api_key
  end

  def api_key=(api_key)
    @api_key = api_key
  end

  def default_headers
    { "User-Agent" => USER_AGENT }.tap do |headers|
      headers["X-M2X-KEY"] = api_key if api_key
    end
  end

  def request(verb, path, qs=nil, params=nil, headers=nil)
    url = URI.parse(File.join(api_base, path))

    url.query = URI.encode_www_form(qs) unless qs.nil? || qs.empty?

    headers = default_headers.merge(headers || {})

    body = if params
             headers["Content-Type"] ||= "application/x-www-form-urlencoded"

             case headers["Content-Type"]
             when "application/json" then JSON.dump(params)
             when "application/x-www-form-urlencoded" then URI.encode_www_form(params)
             else
               raise ArgumentError, "Unrecognized Content-Type `#{headers["Content-Type"]}`"
             end
           end

    options = {}
    options.merge!(use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_PEER, ca_file: CA_FILE) if url.scheme == "https"

    path = url.path
    path << "?#{url.query}" if url.query

    res = Net::HTTP.start(url.host, url.port, options) do |http|
      http.send_request(verb.to_s.upcase, path, body, headers)
    end

    Response.new(res)
  end

  [:get, :post, :put, :delete, :head, :options, :patch].each do |verb|
    define_method verb do |path, qs=nil, params=nil, headers=nil|
      request(verb, path, qs, params, headers)
    end
  end

  def status
    get("/status")
  end

  def device
    M2X::Client::Device
  end

  def devices
    M2X::Client::Device.list
  end

  def keys
    @keys ||= M2X::Client::Key.new(self)
  end

  def streams
    @streams ||= M2X::Client::Stream.new(self)
  end

  def distributions
    @distributions ||= M2X::Client::Distribution.new(self)
  end

  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def raw
      @response.body
    end

    def json
      raise "#{@response.content_type} is not application/json" unless @response.content_type == "application/json"

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
end
