require 'faraday'
require 'sinatra/base'
require 'sinatra/multi_route'

require 'kibana/rack/version'
require 'kibana/rack/web'

module Kibana
  DEFAULT_ELASTICSEARCH_HOST = 'localhost'
  DEFAULT_ELASTICSEARCH_PORT = 9200
  DEFAULT_KIBANA_DASHBOARDS_PATH = File.expand_path('../../../dashboards', __FILE__)
  DEFAULT_KIBANA_DEFAULT_ROUTE = '/dashboard/file/default.json'
  DEFAULT_KIBANA_INDEX = 'kibana-int'

  class << self
    attr_accessor :elasticsearch_host, :elasticsearch_port
    attr_accessor :kibana_dashboards_path, :kibana_default_route, :kibana_index

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
