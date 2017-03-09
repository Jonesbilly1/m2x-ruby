module M2X::Client::Metadata

  #
  # Method for
  # {https://m2x.att.com/developer/documentation/v2/device#Read-Device-Metadata Read Device Metadata},
  # {https://m2x.att.com/developer/documentation/v2/distribution#Read-Distribution-Metadata Read Distribution Metadata},
  # {https://m2x.att.com/developer/documentation/v2/collections#Read-Collection-Metadata Read Collection Metadata} endpoints.
  # @return {Response} The API response, see M2X API docs for details
  #
  def read_metadata
    @client.get(metadata_path)
  end

  #
  # Method for
  # {https://m2x.att.com/developer/documentation/v2/device#Read-Device-Metadata-Field Read Device Metadata Field},
  # {https://m2x.att.com/developer/documentation/v2/distribution#Read-Distribution-Metadata-Field Read Distribution Metadata Field},
  # {https://m2x.att.com/developer/documentation/v2/collections#Read-Collection-Metadata-Field Read Collection Metadata Field} endpoints.
  #
  # @param (String) field_name The metada field to be read
  # @return {Response} The API response, see M2X API docs for details
  #
  def read_metadata_field(field_name)
    @client.get("#{metadata_path}/#{field_name}")
  end

  #
  # Method for
  # {https://m2x.att.com/developer/documentation/v2/device#Update-Device-Metadata Update Device Metadata},
  # {https://m2x.att.com/developer/documentation/v2/distribution#Update-Distribution-Metadata Update Distribution Metadata},
  # {https://m2x.att.com/developer/documentation/v2/collections#Update-Collection-Metadata Update Collection Metadata} endpoints.
  #
  # @param params Query parameters passed as keyword arguments. View M2X API Docs for listing of available parameters.
  # @return {Response} The API response, see M2X API docs for details
  #
  def update_metadata(params)
    @client.put(metadata_path, nil, params, "Content-Type" => "application/json")
  end

  #
  # Method for
  # {https://m2x.att.com/developer/documentation/v2/device#Update-Device-Metadata-Field Update Device Metadata Field},
  # {https://m2x.att.com/developer/documentation/v2/distribution#Update-Distribution-Metadata-Field Update Distribution Metadata Field},
  # {https://m2x.att.com/developer/documentation/v2/collections#Update-Collection-Metadata-Field Update Collection Metadata Field} endpoints.
  #
  # @param (String) field_name The metadata field to be updated
  # @param (String) value The value to be updated
  # @return {Response} The API response, see M2X API docs for details
  #
  def update_metadata_field(field_name, value)
    @client.put("#{metadata_path}/#{field_name}", nil, { value: value }, "Content-Type" => "application/json")
  end

  def metadata_path
    "#{path}/metadata"
  end
end
