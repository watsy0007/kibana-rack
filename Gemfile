source 'https://rubygems.org'

gemspec

group :development do
  gem 'overcommit', '~> 0.16'
  gem 'rails', '~> 4.1'
  gem 'rake', '~> 10.3'
end

group :lint do
  gem 'inch', '~> 0.4'
  gem 'rubocop', '~> 0.24'
end

group :test do
  gem 'coveralls', '~> 0.7', require: false
  gem 'rspec', '~> 3.0'
  gem 'webmock', '~> 1.18', require: false
end

group :debugger do
  gem 'pry-byebug', '~> 1.3'
end

group :docs do
  gem 'github-markup', '~> 1.2'
  gem 'redcarpet', '~> 3.1'
  gem 'yard', github: 'lsegal/yard'
end
