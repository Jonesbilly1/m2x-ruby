# AT&T's M2X Ruby Client

[AT&T’s M2X](https://m2x.att.com/) is a cloud-based fully managed data storage service for network connected machine-to-machine (M2M) devices. From trucks and turbines to vending machines and freight containers, M2X enables the devices that power your business to connect and share valuable data.

This gem aims to provide a simple wrapper to interact with [AT&T M2X API](https://m2x.att.com/developer/documentation/overview).

## Glossary

### API key

An API key is a automatically generated token associated with your AT&T M2X account. Whenever you create an account you will be assigned a _Primary API Master Key_. This key cannot be edited nor deleted and will give you full access to the whole API. It is recommendable to [create a new Master API Key](https://m2x.att.com/account#master-keys-tab).

Each Data Source that you create comes by default with a _Data Source API Key_ that has full access to it and cannot be edited nor deleted. As with Master Keys, it is recommendable to create a new one from the Data Source details page, under the _API Keys_ tab. This keys are valid to access only to resources on the given Data Source. As an additional level of permission, you can create a _Data Source Stream API Key_ that can only access to the selected Stream under that Data Source.

### Other terms

For all other terms used in this documentation, see the [official glossary](https://m2x.att.com/developer/documentation/glossary).

## Usage

In order to be able to use this gem you will need an [AT&T M2X](https://m2x.att.com/) account to obtain an API key.

	require "m2x"
	
	m2x = M2X.new("<YOUR-API-KEY>")
	
	# List all your keys
	keys = m2x.keys.list.json["keys"]
	
	keys.each do |key|
	  puts key["name"]
	  puts key["key"]
	  puts key["permissions"]
	end

## Versioning

This gem aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). As a summary, given a version number `MAJOR.MINOR.PATCH`:

1. `MAJOR` will increment when incompatible API changes are introduced.
2. `MINOR` will increment when backwards-compatible functionality is added.
3. `PATCH` will increment with backwards-compatible bug fixes.

Additional labels for pre-release and build metadata are available as extensions to the `MAJOR.MINOR.PATCH` format.

## License

This gem is delivered under the MIT license. See [LICENSE](LICENSE) for the terms.
