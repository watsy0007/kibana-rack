require 'faraday'

module Kibana
  module Rack
    class Proxy
      DEFAULT_ELASTICSEARCH_HOST = 'localhost'
      DEFAULT_ELASTICSEARCH_PORT = 9200

      def initialize(options = {})
        @host = options.fetch(:host, DEFAULT_ELASTICSEARCH_HOST)
        @port = options.fetch(:port, DEFAULT_ELASTICSEARCH_PORT)
      end

      def request(method, path, headers = {}, params = {}, body = nil)
        response = connection.send(method) do |req|
          req.url(path)
          req.headers = headers
          req.params = params
          req.body = body
        end

        [response.status, response.headers, response.body]
      end

      private

      attr_reader :host, :port

      def connection
        @connection ||= Faraday.new(url: "http://#{host}:#{port}")
      end
    end
  end
end
