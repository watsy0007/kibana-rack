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
        def proxy
          es_host = settings.elasticsearch_host
          es_port = settings.elasticsearch_port
          @proxy ||= Faraday.new(url: "http://#{es_host}:#{es_port}")
        end

        def proxy_es_request
          request.body.rewind

          proxy_method = request.request_method.downcase.to_sym
          proxy_response = proxy.send(proxy_method) do |proxy_request|
            proxy_request.url(request.path_info)
            proxy_request.headers['Content-Type'] = 'application/json'
            proxy_request.params = env['rack.request.query_hash']
            proxy_request.body = request.body.read if proxy_method == :post
          end

          [proxy_response.status, proxy_response.headers, proxy_response.body]
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

        halt(404, { 'Content-Type' => 'application/json' }, '{"error":"Not found"}') unless File.exist?(dashboard_path)

        template = IO.read(dashboard_path)
        content_type "application/#{dashboard_ext}"
        erb template
      end

      route(:delete, :get, :post, :put, '/_aliases') do
        proxy_es_request
      end
      route(:delete, :get, :post, :put, '/_nodes') do
        proxy_es_request
      end

      route(:delete, :get, :post, :put, '/:index/_aliases') do
        proxy_es_request
      end
      route(:delete, :get, :post, :put, '/:index/_mapping') do
        proxy_es_request
      end
      route(:delete, :get, :post, :put, '/:index/_search') do
        proxy_es_request
      end
    end
  end
end
