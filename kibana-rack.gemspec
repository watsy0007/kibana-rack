lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kibana/rack/version'

Gem::Specification.new do |spec|
  spec.name          = 'kibana-rack'
  spec.version       = Kibana::Rack::VERSION
  spec.authors       = ['Tony Burns']
  spec.email         = ['tony@tabolario.com']
  spec.summary       = 'Embed Kibana as a Rack application'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/tabolario/kibana-rack'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^spec\//)
  spec.require_paths = ['lib']

  spec.cert_chain = %w(tabolario.pem)
  spec.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $PROGRAM_NAME =~ /gem\z/

  spec.add_dependency 'faraday',         '~> 0.9.2'
  spec.add_dependency 'sinatra',         '~> 1.4.7'
  spec.add_dependency 'sinatra-contrib', '~> 1.4.7'

  spec.add_development_dependency 'bundler', '~> 1.6'
end
