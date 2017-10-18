# AT&T M2X Ruby Client

[AT&T M2X](http://m2x.att.com) is a cloud-based fully managed time-series data storage service for network connected machine-to-machine (M2M) devices and the Internet of Things (IoT).

The [AT&T M2X API](https://m2x.att.com/developer/documentation/overview) provides all the needed operations and methods to connect your devices to AT&T's M2X service. This library aims to provide a simple wrapper to interact with the AT&T M2X API for [Ruby](https://www.ruby-lang.org/en/). Refer to the [Glossary of Terms](https://m2x.att.com/developer/documentation/glossary) to understand the nomenclature used throughout this documentation.

Getting Started
==========================
1. Signup for an [M2X Account](https://m2x.att.com/signup).
2. Obtain your _Master Key_ from the Master Keys tab of your [Account Settings](https://m2x.att.com/account) screen.
2. Create your first [Device](https://m2x.att.com/devices) and copy its _Device ID_.
3. Review the [M2X API Documentation](https://m2x.att.com/developer/documentation/overview).

## Installation

```bash
$ gem install m2x
```

## Usage

In order to communicate with the M2X API, you need an instance of [M2X::Client](lib/m2x/client.rb). You need to pass your API key in the constructor to access your data.

```ruby
m2x = M2X::Client.new(<YOUR-API-KEY>)
```

This provides an interface to your data in M2X

- [Distribution](lib/m2x/distribution.rb)
  ```ruby
  distribution = m2x.distribution("<DISTRIBUTION-ID>")

  distributions = m2x.distributions
  ```

- [Device](lib/m2x/device.rb)
  ```ruby
  device = m2x.device("<DEVICE-ID>")

  devices = m2x.devices
  ```

- [Collection](lib/m2x/collection.rb)
  ```ruby
  collection = m2x.collection("<COLLECTION-ID>")

  collections = m2x.collections
  ```

- [Key](lib/m2x/key.rb)
  ```ruby
  key = m2x.key("<KEY-TOKEN>")

  keys = m2x.keys
  ```

- [Job](lib/m2x/job.rb)
  ```ruby
  job = m2x.job("<JOB-ID>")
  ```

- [Integration](lib/m2x/integration.rb)
  ```ruby
  integration = m2x.integration("<INTEGRATION-ID>")

  integrations = m2x.integrations
  ```

Refer to the documentation on each class for further usage instructions.

## Time

For devices that do not have a Real Time Clock, M2X provides a set of endpoints that returns the server's time.

```ruby
m2x.time
=> {"seconds"=>1435970368, "millis"=>1435970368451, "iso8601"=>"2015-07-04T00:39:28.451Z"}

m2x.time_seconds
=> "1435970400"

m2x.time_millis
=> "1435970418134"

m2x.time_iso8601
=> "2015-07-04T00:40:37.504Z"
```

## Examples

Scripts demonstrating usage of the M2X Ruby Client Library can be found in the [examples](/examples) directory. Each example leverages system environment variables to inject user specific information such as the M2X `API Key` or `Device ID`. Review the example you would like to try first to determine which environment variables are required (hint: search for `ENV.fetch` in the example). Then make sure to set the required environment variable(s) when running the script.

For example, in order to run the [m2x-uptime](/examples/m2x-uptime.rb) script, you will need a `Device ID` and `API Key`. If you have yet to create an M2X Device, access your M2X account, create a new [Device](https://m2x.att.com/devices), and copy the `Device ID` and `API Key` values. The script will send your CPU load average to three different streams named `load_1m`, `load_5m` and `load_15`. In order to execute this script, run:

```bash
$ API_KEY=<YOUR-API-KEY> DEVICE=<YOUR-DEVICE-ID> ruby ./m2x-uptime.rb
```

## Tutorials

Please refer to the [M2X Ruby Client Tutorials](TUTORIAL.md) for additional hands on examples.

## Versioning

This gem aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). As a summary, given a version number `MAJOR.MINOR.PATCH`:

1. `MAJOR` will increment when backwards-incompatible changes are introduced to the client.
2. `MINOR` will increment when backwards-compatible functionality is added.
3. `PATCH` will increment with backwards-compatible bug fixes.

Additional labels for pre-release and build metadata are available as extensions to the `MAJOR.MINOR.PATCH` format.

**Note**: the client version does not necessarily reflect the version used in the AT&T M2X API.

## License

This gem is provided under the MIT license. See [LICENSE](LICENSE) for applicable terms.
