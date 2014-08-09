ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __FILE__)
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

require 'kibana/rack'

ENV['EXAMPLE_NAME'] = 'Rack Example'

Kibana.configure do |config|
  config.kibana_dashboards_path = File.expand_path('../../dashboards', __FILE__)
end

map '/kibana' do
  run Kibana::Rack::Web
end
