# kibana-rack [![Kibana Version](https://img.shields.io/badge/kibana%20version-3.1.0-orange.svg)](http://www.elasticsearch.org/overview/kibana/)

[![Gem Version](https://img.shields.io/gem/v/kibana-rack.svg)](https://rubygems.org/gems/kibana-rack)
[![Dependency Status](https://gemnasium.com/tabolario/kibana-rack.svg)](https://gemnasium.com/tabolario/kibana-rack)
[![Build Status](https://travis-ci.org/tabolario/kibana-rack.svg?branch=master)](https://travis-ci.org/tabolario/kibana-rack)
[![Code Climate](https://img.shields.io/codeclimate/github/tabolario/kibana-rack.svg)](https://codeclimate.com/github/tabolario/kibana-rack)
[![Coverage Status](https://img.shields.io/coveralls/tabolario/kibana-rack.svg)](https://coveralls.io/r/tabolario/kibana-rack?branch=master)
[![Inline docs](http://inch-ci.org/github/tabolario/kibana-rack.svg)](http://inch-ci.org/github/tabolario/kibana-rack)

Embed [Kibana](http://www.elasticsearch.org/overview/kibana/) as a [Rack](http://rack.github.io/) application.

Kibana is a beautiful and powerful dashboard built on top of [Elasticsearch](http://www.elasticsearch.org/). It's great for viewing logs indexed by tools like [logstash](http://logstash.net/) and exploring data on Elasticsearch in general.

kibana-rack tracks the latest version of Kibana (currently 3.1.0) and embeds it directly in your application, along with a proxy for the Elasticsearch API endpoints that Kibana needs.

Kibana dashboards can be created using ERB-processed JSON files in the directory specified by your kibana-rack configuration.

## Requirements

* Ruby 2.1+ (kibana-rack is developed and tested with Ruby 2.1.2)

## Installation

Add this line to your application's Gemfile:

    gem 'kibana-rack', '~> 0.1.0'

And then execute:

    $ bundle

### Rails

**Note: kibana-rails is coming soon!**

Create an initializer at `config/initializers/kibana.rb` to configure kibana-rack:

```ruby
Kibana.configure do |config|
  config.elasticsearch_host = 'localhost'
  config.elasticsearch_port = 9200
  config.kibana_dashboards_path = Rails.root.join('app/kibana')
  config.kibana_default_route = '/dashboard/file/default.json'
  config.kibana_index = 'kibana-int'
end
```

Modify `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount Kibana::Rack::Web => '/kibana'
end
```

### Sinatra and other Rack applications

Configure kibana-rack:

```ruby
Kibana.configure do |config|
  config.elasticsearch_host = 'localhost'
  config.elasticsearch_port = 9200
  config.kibana_dashboards_path = File.expand_path('../path/to/dashboards', __FILE__)
  config.kibana_default_route = '/dashboard/file/default.json'
  config.kibana_index = 'kibana-int'
end
```

Mount kibana-rack with [Rack::Builder](http://rubydoc.info/github/rack/rack/master/Rack/Builder):

```ruby
class MyRackApplication < Sinatra::Base
  ...
end

app = Rack::Builder.new do
  map('/kibana') { use Kibana::Rack::Web }
  run MyRackApplication
end

run app
```

## Usage

See the [Kibana documentation](http://www.elasticsearch.org/guide/en/kibana/current/index.html) for information on how to use Kibana.

## Configuration

kibana-rack is configured by default to serve the dashboards that come in the gem (see the [dashboards](https://github.com/tabolario/kibana-rack/tree/master/dashboards) directory), and proxy to Elasticsearch on `localhost:9200`. It is recommended that you maintain your own dashboards directory inside of the application that kibana-rack is mounted in. Production deployments will also most likely need to configure the address of Elasticsearch.

The following settings are available as accessors on the object yielded to from `Kibana.configure`:

```ruby
Kibana.configure do |config|
  config.elasticsearch_host = '10.0.8.9'
  ...
end
```

| Name                     | Description                                                                                     |
| ------------------------ | ----------------------------------------------------------------------------------------------- |
| `elasticsearch_host`     | The host of the Elasticsearch instance to proxy to. Default: `localhost`                        |
| `elasticsearch_port`     | The port of the Elasticsearch instance to proxy to. Default: `9200`                             |
| `kibana_dashboards_path` | The directory to look for dashboards in. Default: `dashboards` directory inside of kibana-rack  |
| `kibana_default_route`   | The default path that Kibana will load. Default: `/dashboard/file/default.json`                 |
| `kibana_index`           | The name of the Elasticsearch index Kibana will use for internal storage. Default: `kibana-int` |

## Securing the `/kibana` endpoint

Kibana is very useful to have in production for things like searching logs and exploring Elasticsearch indexes. When using kibana-rack in a production environment, be sure to secure it from unauthorized access.

### Devise

In `config/routes.rb`:

```ruby
authenticate :user do
  mount Kibana::Rack::Web => '/kibana'
end
```

Or authenticate only if `User#admin?` returns true for `current_user`:

```ruby
authenticate :user, ->(user) { user.admin? } do
  mount Kibana::Rack::Web => '/kibana'
end
```

### Rack with HTTP basic authentication

```ruby
require 'kibana/rack'

map '/kibana' do
  use Rack::Auth::Basic, 'Restricted Access' do |username, password|
    username == 'kibana' && password == 'kibana'
  end

  run Kibana::Rack::Web
end
```

## Documentation

See the [examples](https://github.com/tabolario/kibana-rack/tree/master/examples) directory for installation and configuration examples.

See the [YARD documentation](http://rdoc.info/github/tabolario/kibana-rack) for the latest API documentation.

Generate local documentation with YARD (output to the `doc` directory):

    $ bundle exec rake yard

## Support

* [GitHub Issues](https://github.com/tabolario/kibana-rack/issues)
* Email: [tony@tabolario.com](mailto:tony@tabolario.com)
* Twitter: [@tabolario](https://twitter.com/tabolario)

## Development and testing

kibana-rack follows the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) for style conventions, with a few exceptions. See [.rubocop.yml](https://github.com/tabolario/kibana-rack/blob/master/.rubocop.yml) for the details.

Run linters ([RuboCop](https://github.com/bbatsov/rubocop) and [Inch](https://github.com/rrrene/inch)):

    $ bundle exec rake lint

Run tests:

    $ bundle exec rake spec

Install pre-commit hooks for [overcommit](https://github.com/causes/overcommit) (configuration is in [.overcommit.yml](https://github.com/tabolario/kibana-rack/blob/master/.overcommit.yml)):

    $ gem install overcommit
    $ overcommit --install

## Security

### Installation

kibana-rack is cryptographically signed. To be sure the gem you install hasn't been tampered with, add my public key (if you haven't already) as a trusted certificate:

    $ gem cert --add <(curl -Ls https://raw.github.com/tabolario/kibana-rack/master/tabolario.pem)

Installing the gem with the MediumSecurity trust profile will verify all signed gems, but allow the installation of unsigned dependencies:

    $ gem install kibana-rack -P MediumSecurity

You can also set the trust file for Bundler:

    $ bundle --trust-policy MediumSecurity

Using the MediumSecurity policy is often necessary because not all of your dependencies may not be signed, so HighSecurity is not an option.

### Reporting Security Issues

If you have discovered an issue with kibana-rack of a sensitive nature that could compromise the security of kibana-rack users, **please report it securely by sending a GPG-encrypted message instead of filing an issue on GitHub**. Please use the following key and send your report to [tony@tabolario.com](mailto:tony@tabolario.com).

[https://raw.github.com/tabolario/kibana-rack/tabolario.gpg](https://raw.github.com/tabolario/kibana-rack/tabolario.gpg)

The fingerprint of the key should be:

    6EED 2359 968F 7734 06A4 AB56 D90E 487A 60F1 0579

## Contributing

See [CONTRIBUTING.md](https://github.com/tabolario/kibana-rack/blob/master/CONTRIBUTING.md) for full information on how to contribute to kibana-rack.

## Release process

kibana-rack follows [Semver 2.0.0](http://semver.org/spec/v2.0.0.html) for release versioning. The version number components X.Y.Z have the following meanings:

* X for **Major** releases that may contain backwards-incompatible changes.
* Y for **Minor** releases that may contain features, bug fixes, and backwards-compatible changes.
* Z for **Patch** releases that only contain bug fixes and trivial changes.

**Pre-release** versions like `X.Y.Z.alpha.0` and `X.Y.Z.beta.1` will be made before **Major**, and **Minor** versions. Pre-release versions are well-tested, but not as thoroughly as the versions that they precede.

Whenever a new version is made, it will be tagged as a release on [GitHub Releases](https://github.com/tabolario/kibana-rack/releases) and pushed to [RubyGems](https://rubygems.org/gems/kibana-rack). Entries in [CHANGELOG.md](https://github.com/tabolario/kibana-rack/blob/master/CHANGELOG.md) will be made incrementally up to the release. An announcement will also be made on Twitter.

When a new **Major** version is made, a corresponding branch will be created named `X-0-0` for further **Minor** and **Patch** releases on that version.

## Todo

* kibana-rails gem for easy integration with Ruby on Rails applications
* A Ruby DSL for defining dashboards
* Example dashboards for common use cases

## License

### kibana-rack

|               |                                                                           |
| ------------- | ------------------------------------------------------------------------- |
| **Author**    | Tony Burns <[tony@tabolario.com](mailto:tony@tabolario.com)>              |
| **Copyright** | Copyright (c) 2014 Tony Burns                                             |
| **License**   | [MIT License](http://opensource.org/licenses/MIT)                         |

```text
MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

### Kibana

|               |                                                                           |
| ------------- | ------------------------------------------------------------------------- |
| **Copyright** | Copyright 2012-2013 Elasticsearch BV                                      |
| **License**   | [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) |
