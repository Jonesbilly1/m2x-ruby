# Wrapper for {https://m2x.att.com/developer/documentation/v2/integrations M2X Integrations} API
class M2X::Client::Integration < M2X::Client::Resource
  PATH = "/integrations"

  class << self
    #
    # Method for {https://m2x.att.com/developer/documentation/v2/integrations#List-Integrations List Integrations} endpoint.
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return (Array) List of {Integration} objects
    #
    def list(client, params={})
      res = client.get(PATH, params)

      res.json["integrations"].map{ |atts| new(client, atts) } if res.success?
    end

    #
    # Method for {https://m2x.att.com/developer/documentation/v2/integrations#Create-Integration Create Integration} endpoint.
    #
    # @param {Client} client Client API
    # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
    # @return {Device} newly created device.
    #
    def create!(client, params)
      res = client.post(PATH, nil, params, "Content-Type" => "application/json")

      new(client, res.json) if res.success?
    end
  end

  def path
    @path ||= "#{ PATH }/#{ URI.encode(@attributes.fetch("id")) }"
  end

  # Method for {https://m2x.att.com/developer/documentation/v2/integrations#Update-Integration-Status Update Integration Status} endpoint.
  #
  # @param (String) id Command ID to process
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} The API response, see M2X API docs for details
  #
  def update_status(params = {})
    @client.put("#{path}/status", nil, params)
  end

  # Method for {https://m2x.att.com/developer/documentation/v2/integrations#View-Integration-Status-Details View Integration Status Details} endpoint.
  #
  # @param (String) id Command ID to process
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} The API response, see M2X API docs for details
  #
  def view_status
    @client.get("#{path}/status")
  end
end
