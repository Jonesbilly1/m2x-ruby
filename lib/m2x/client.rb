require "net/http"
require "json"
require "openssl"
require "forwardable"

class M2X::Client
  API_BASE = "https://api-m2x.att.com/v2".freeze

  CA_FILE = File.expand_path("../cacert.pem", __FILE__)

  USER_AGENT = "M2X/#{::M2X::Client::VERSION} (Ruby #{RUBY_VERSION}; #{RUBY_PLATFORM})".freeze

  attr_accessor :api_key
  attr_accessor :api_base
  attr_reader   :last_response

  def initialize(api_key=nil, api_base=nil)
    @api_base = api_base
    @api_key  = api_key
  end

  def status
    get("/status")
  end

  def device(id)
    M2X::Client::Device.new(self, "id" => id)
  end

  def create_device(params)
    M2X::Client::Device.create(self, params)
  end

  def devices(params={})
    M2X::Client::Device.list(self, params)
  end

  def device_catalog(params={})
    M2X::Client::Device.catalog(self, params)
  end

  def distribution(id)
    M2X::Client::Distribution.new(self, "id" => id)
  end

  def create_distribution(params)
    M2X::Client::Distribution.create(self, params)
  end

  def distributions(params={})
    M2X::Client::Distribution.list(self, params)
  end

  def key(key)
    M2X::Client::Key.new(self, "key" => key)
  end

  def create_key(params)
    M2X::Client::Key.create(self, params)
  end

  def keys
    M2X::Client::Key.list(self)
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

    @last_response = Response.new(res)
  end

  [:get, :post, :put, :delete, :head, :options, :patch].each do |verb|
    define_method verb do |path, qs=nil, params=nil, headers=nil|
      request(verb, path, qs, params, headers)
    end
  end

  private
  def api_base
    @api_base ||= API_BASE
  end

  def default_headers
    @headers ||= { "User-Agent" => USER_AGENT }.tap do |headers|
                   headers["X-M2X-KEY"] = @api_key if @api_key
                 end
  end
end
