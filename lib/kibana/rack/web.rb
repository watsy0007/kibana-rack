require 'kibana/rack/proxy'

module Kibana
  module Rack
    # Rack application that serves Kibana and proxies requests to Elasticsearch
    class Web < Sinatra::Base
      register Sinatra::MultiRoute

      set :root, File.expand_path('../../../../web', __FILE__)
      set :public_folder, -> { "#{root}/assets" }
      set :views, -> { "#{root}/views" }

      set :elasticsearch_host, -> { Kibana.elasticsearch_host }
      set :elasticsearch_port, -> { Kibana.elasticsearch_port }
      set :kibana_dashboards_path, -> { Kibana.kibana_dashboards_path }
      set :kibana_default_route, -> { Kibana.kibana_default_route }
      set :kibana_index, -> { Kibana.kibana_index }

      helpers do
        def validate_kibana_index_name
          render_not_found unless params[:index] == settings.kibana_index
        end

        def proxy
          @proxy ||= begin
            host = settings.elasticsearch_host
            port = settings.elasticsearch_port
            Proxy.new(host: host, port: port)
          end
        end

        def proxy_es_request
          request.body.rewind

          proxy_method = request.request_method.downcase.to_sym
          proxy_path = request.path_info
          proxy_headers = { 'Content-Type' => 'application/json' }
          proxy_params = env['rack.request.query_hash']
          proxy_body = request.body.read if %i(post put).include?(proxy_method)

          proxy.request(proxy_method, proxy_path, proxy_headers, proxy_params, proxy_body)
        end

        def render_not_found
          halt(404, '<h1>Not Found</h1>')
        end
      end

      get '/' do
        erb :index
      end

      get '/config.js' do
        content_type 'application/javascript'
        erb :config
      end

      get(%r{/app/dashboards/([\w-]+)\.(js(on)?)}) do
        dashboard_name = params[:captures][0]
        dashboard_ext = params[:captures][1]
        dashboard_path = File.join(settings.kibana_dashboards_path, "#{dashboard_name}.#{dashboard_ext}")

        render_not_found unless File.exist?(dashboard_path)

        template = IO.read(dashboard_path)
        content_type "application/#{dashboard_ext}"
        erb template
      end

      %w(
        _aliases
        _nodes
        :index/_aliases
        :index/_mapping
        :index/_search
      ).each do |path|
        route(:delete, :get, :post, :put, "/#{path}") do
          proxy_es_request
        end
      end

      %w(
        :index/temp
        :index/temp/:name
        :index/dashboard/:dashboard
      ).each do |path|
        route(:delete, :get, :post, :put, "/#{path}") do
          validate_kibana_index_name
          proxy_es_request
        end
      end
    end
  end
end
