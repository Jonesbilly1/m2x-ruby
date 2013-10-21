# AT&T's M2X Ruby Client

[AT&T’s M2X](https://m2x.att.com/) is a cloud-based fully managed data storage service for network connected machine-to-machine (M2M) devices. From trucks and turbines to vending machines and freight containers, M2X enables the devices that power your business to connect and share valuable data.

This gem aims to provide a simple wrapper to interact with [AT&T M2X API](https://m2x.att.com/developer/documentation/overview).

## Glossary

### API key

An API key is a automatically generated token associated with your AT&T M2X account. Whenever you create an account you will be assigned a _Primary API Master Key_. This key cannot be edited nor deleted and will give you full access to the whole API. It is recommendable to [create a new Master API Key](https://m2x.att.com/account#master-keys-tab).

Each Data Source that you create comes by default with a _Data Source API Key_ that has full access to it and cannot be edited nor deleted. As with Master Keys, it is recommendable to create a new one from the Data Source details page, under the _API Keys_ tab. These keys can only access resources from the given Data Source. As an additional level of permission, you can create a _Data Source Stream API Key_ that can only access the selected Stream under that Data Source.

### Other terms

For all other terms used in this documentation, see the [official glossary](https://m2x.att.com/developer/documentation/glossary).

## Example Usage

In order to be able to use this gem you will need an [AT&T M2X](https://m2x.att.com/) account to obtain an API key. Once registered and with your account activated, create a new [Data Source Blueprint](https://m2x.att.com/blueprints), and copy the `Feed ID` and `API Key` values. The following script will send your CPU load average to three different streams named `load_1m`, `load_5m` and `load_15`. Check that there's no need to create a stream in order to write values into it:

    #! /usr/bin/env ruby

    #
    # See https://github.com/attm2x/m2x-ruby/blob/master/README.md#example-usage
    # for instructions
    #

    require "m2x"

    API_KEY = "<YOUR-FEED-API-KEY>"
    FEED    = "<YOUR-FEED-ID>"

    m2x = M2X.new(API_KEY)

    @run = true
    trap(:INT) { @run = false }

    # Match `uptime` load averages output for both Linux and OSX
    UPTIME_RE = /(\d+\.\d+),? (\d+\.\d+),? (\d+\.\d+)$/

    while @run
      load_1m, load_5m, load_15m = `uptime`.match(UPTIME_RE).captures

      # Write the different values into AT&T M2X
      m2x.feeds.update_stream(FEED, "load_1m",  value: load_1m)
      m2x.feeds.update_stream(FEED, "load_5m",  value: load_5m)
      m2x.feeds.update_stream(FEED, "load_15m", value: load_15m)

      sleep 1
    end

    puts

You can find the script in [`examples/m2x-uptime.rb`](examples/m2x-uptime.rb).

## Versioning

This gem aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). As a summary, given a version number `MAJOR.MINOR.PATCH`:

1. `MAJOR` will increment when incompatible API changes are introduced.
2. `MINOR` will increment when backwards-compatible functionality is added.
3. `PATCH` will increment with backwards-compatible bug fixes.

Additional labels for pre-release and build metadata are available as extensions to the `MAJOR.MINOR.PATCH` format.

## License

This gem is delivered under the MIT license. See [LICENSE](LICENSE) for the terms.
