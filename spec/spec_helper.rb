require 'bundler/setup'
require 'simplecov'

Bundler.require(:test)
Bundler.require(:debugger) unless ENV.key?('CI')

ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kibana/rack'

require 'rack/test'
require 'webmock/rspec'

RSpec.configure do |config|
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.filter_run :focus
  config.order = :random
  config.profile_examples = 10
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  Kernel.srand config.seed
end
