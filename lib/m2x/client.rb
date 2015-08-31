require "net/http"
require "json"
require "openssl"

# Interface for connecting with M2X API service.
#
# This class provides convenience methods to access M2X most common resources.
# It can also be used to access any endpoint directly like this:
#
#     m2x = M2X::Client.new("<YOUR-API-KEY>")
#     m2x.get("/some_path")
#
class M2X::Client
  DEFAULT_API_BASE    = "https://api-m2x.att.com".freeze
  DEFAULT_API_VERSION = "v2".freeze

  CA_FILE = File.expand_path("../cacert.pem", __FILE__)

  USER_AGENT = "M2X-Ruby/#{M2X::Client::VERSION} #{RUBY_ENGINE}/#{RUBY_VERSION} (#{RUBY_PLATFORM})".freeze

  attr_accessor :api_key
  attr_accessor :api_base
  attr_accessor :api_version
  attr_reader   :last_response

  def initialize(api_key=nil, api_base=nil)
    @api_key     = api_key
    @api_base    = api_base
    @api_version = api_version
  end

  # Returns the status of the M2X system.
  #
  # The response to this endpoint is an object in which each of its attributes
  # represents an M2X subsystem and its current status.
  def status
    get("/status")
  end

  # Obtain a Device from M2X
  #
  # This method instantiates an instance of Device and calls `Device#view`
  # method, returning the device instance with all its attributes initialized
  def device(id)
    M2X::Client::Device.new(self, "id" => id).tap(&:view)
  end

  # Creates a new device on M2X with the specified parameters
  def create_device(params)
    M2X::Client::Device.create!(self, params)
  end

  # Retrieve the list of devices accessible by the authenticated API key
  #
  # See M2X::Client::Device.list for more details
  def devices(params={})
    M2X::Client::Device.list(self, params)
  end

  # Retrieve the list of devices accessible by the authenticated API key that
  # meet the search criteria.
  #
  # See M2X::Client::Device.search for more details
  def search_devices(params={})
    M2X::Client::Device.list(self, params)
  end

  # Search the catalog of public Devices.
  #
  # This allows unauthenticated users to search Devices from other users that
  # have been marked as public, allowing them to read public Device metadata,
  # locations, streams list, and view each Devices' stream metadata and its
  # values.
  #
  # See M2X::Client::Device.catalog for more details
  def device_catalog(params={})
    M2X::Client::Device.catalog(self, params)
  end

  # Obtain a Distribution from M2X
  #
  # This method instantiates an instance of Distribution and calls
  # `Distribution#view` method, returning the device instance with all
  # its attributes initialized
  def distribution(id)
    M2X::Client::Distribution.new(self, "id" => id).tap(&:view)
  end

  # Creates a new device distribution on M2X with the specified parameters
  def create_distribution(params)
    M2X::Client::Distribution.create!(self, params)
  end

  # Retrieve list of device distributions accessible by the authenticated
  # API key.
  #
  # See M2X::Client::Distribution.list for more details
  def distributions(params={})
    M2X::Client::Distribution.list(self, params)
  end

  # Obtain a Job from M2X
  #
  # This method instantiates an instance of Job and calls `Job#view`
  # method, returning the job instance with all its attributes initialized
  def job(id)
    M2X::Client::Job.new(self, "id" => id).tap(&:view)
  end

  # Obtain an API Key from M2X
  #
  # This method instantiates an instance of Key and calls
  # `Key#view` method, returning the key instance with all
  # its attributes initialized
  def key(key)
    M2X::Client::Key.new(self, "key" => key).tap(&:view)
  end

  # Create a new API Key
  #
  # Note that, according to the parameters sent, you can create a
  # Master API Key or a Device/Stream API Key.
  #
  # See M2X::Client::Key.create! for more details
  def create_key(params)
    M2X::Client::Key.create!(self, params)
  end

  # Retrieve list of keys associated with the user account.
  #
  # See M2X::Client::Key.list for more details
  def keys
    M2X::Client::Key.list(self)
  end

  # Obtain a Collection from M2X
  #
  # This method instantiates an instance of Collection and calls `Collection#view`
  # method, returning the collection instance with all its attributes initialized
  def collection(id)
    M2X::Client::Collection.new(self, "id" => id).tap(&:view)
  end

  # Creates a new collection on M2X with the specified parameters
  def create_collection(params)
    M2X::Client::Collection.create!(self, params)
  end

  # Retrieve the list of collections accessible by the authenticated API key
  #
  # See M2X::Client::Collection.list for more details
  def collections(params={})
    M2X::Client::Collection.list(self, params)
  end

  def time
    get("/time").json
  end

  def time_seconds
    get("/time/seconds").raw
  end

  def time_millis
    get("/time/millis").raw
  end

  def time_iso8601
    get("/time/iso8601").raw
  end

  # Define methods for accessing M2X REST API
  [:get, :post, :put, :delete, :head, :options, :patch].each do |verb|
    define_method verb do |path, qs=nil, params=nil, headers=nil|
      request(verb, path, qs, params, headers)
    end
  end

  private
  def request(verb, path, qs=nil, params=nil, headers=nil)
    url = URI.parse(File.join(api_base, versioned(path)))

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

  def api_base
    @api_base ||= DEFAULT_API_BASE
  end

  def api_version
    @api_version ||= DEFAULT_API_VERSION
  end

  def versioned(path)
    versioned?(path) ? path : "/#{api_version}#{path}"
  end

  def versioned?(path)
    path =~ /^\/v\d+\//
  end

  def default_headers
    @headers ||= { "User-Agent" => USER_AGENT }.tap do |headers|
                   headers["X-M2X-KEY"] = @api_key if @api_key
                 end
  end
end
