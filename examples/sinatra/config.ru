ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __FILE__)
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

require 'kibana/rack'
require 'sinatra/base'

ENV['EXAMPLE_NAME'] = 'Rails Example'

Kibana.configure do |config|
  config.kibana_dashboards_path = File.expand_path('../../dashboards', __FILE__)
end

class SinatraExample < Sinatra::Base
  get '/' do
    'kibana-rack Sinatra example'
  end
end

app = Rack::Builder.app do
  map '/kibana' do
    use Kibana::Rack::Web
  end

  run SinatraExample
end

run app
