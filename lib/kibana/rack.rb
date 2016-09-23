require 'faraday'
require 'sinatra/base'
# require 'sinatra/multi_route'

require 'kibana/rack/version'
require 'kibana/rack/web'

module Kibana
  DEFAULT_ELASTICSEARCH_HOST = 'localhost'
  DEFAULT_ELASTICSEARCH_PORT = 9200
  DEFAULT_KIBANA_DASHBOARDS_PATH = File.expand_path('../../../dashboards', __FILE__)
  DEFAULT_KIBANA_DEFAULT_ROUTE = '/dashboard/file/default.json'
  DEFAULT_KIBANA_INDEX = 'kibana-int'

  class << self
    # The hostname of the Elasticsearch instance to proxy to.
    # @return [String]
    attr_accessor :elasticsearch_host

    # The port of the Elasticsearch instance to proxy to.
    # @return [Fixnum]
    attr_accessor :elasticsearch_port

    # The filesystem path to look for Kibana dashboards.
    # @return [String]
    attr_accessor :kibana_dashboards_path

    # The default client-side location that Kibana navigates to.
    # @return [String]
    attr_accessor :kibana_default_route

    # The name of the internal Elasticsearch index Kibana uses to store metadata and dashboards.
    # @return [String]
    attr_accessor :kibana_index

    # Yields the {Kibana} module to allow configuration of global settings.
    def configure(&block)
      block.call(self)
    end
  end

  configure do |config|
    config.elasticsearch_host = DEFAULT_ELASTICSEARCH_HOST
    config.elasticsearch_port = DEFAULT_ELASTICSEARCH_PORT
    config.kibana_dashboards_path = DEFAULT_KIBANA_DASHBOARDS_PATH
    config.kibana_default_route = DEFAULT_KIBANA_DEFAULT_ROUTE
    config.kibana_index = DEFAULT_KIBANA_INDEX
  end

  module Rack
  end
end
