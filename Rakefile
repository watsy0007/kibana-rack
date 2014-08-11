require 'bundler/setup'
require 'bundler/gem_tasks'
require 'inch/rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard/rake/yardoc_task'

namespace :lint do
  desc 'Lint inline documentation'
  Inch::Rake::Suggest.new(:docs)

  desc 'Lint code style'
  RuboCop::RakeTask.new(:ruby)
end

desc 'Run all linters'
task lint: %w(lint:ruby lint:docs)

desc 'Run all tests'
RSpec::Core::RakeTask.new(:spec)

desc 'Generate documentation'
YARD::Rake::YardocTask.new

task default: %i(lint spec)
