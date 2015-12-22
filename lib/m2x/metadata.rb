module M2X::Client::Metadata

  # Read an object's metadata
  #
  # https://m2x.att.com/developer/documentation/v2/device#Read-Device-Metadata
  # https://m2x.att.com/developer/documentation/v2/distribution#Read-Distribution-Metadata
  # https://m2x.att.com/developer/documentation/v2/collections#Read-Collection-Metadata
  def read_metadata
    @client.get(metadata_path)
  end

  # Read a single field of an object's metadata
  #
  # https://m2x.att.com/developer/documentation/v2/device#Read-Device-Metadata-Field
  # https://m2x.att.com/developer/documentation/v2/distribution#Read-Distribution-Metadata-Field
  # https://m2x.att.com/developer/documentation/v2/collections#Read-Collection-Metadata-Field
  def read_metadata_field(field_name)
    @client.get("#{metadata_path}/#{field_name}")
  end

  # Update an object's metadata
  #
  # https://m2x.att.com/developer/documentation/v2/device#Update-Device-Metadata
  # https://m2x.att.com/developer/documentation/v2/distribution#Update-Distribution-Metadata
  # https://m2x.att.com/developer/documentation/v2/collections#Update-Collection-Metadata
  def update_metadata(params)
    @client.put(metadata_path, nil, params, "Content-Type" => "application/json")
  end

  # Update a single field of an object's metadata
  #
  # https://m2x.att.com/developer/documentation/v2/device#Update-Device-Metadata-Field
  # https://m2x.att.com/developer/documentation/v2/distribution#Update-Distribution-Metadata-Field
  # https://m2x.att.com/developer/documentation/v2/collections#Update-Collection-Metadata-Field
  def update_metadata_field(field_name, value)
    @client.put("#{metadata_path}/#{field_name}", nil, { value: value }, "Content-Type" => "application/json")
  end

  def metadata_path
    "#{path}/metadata"
  end
end
