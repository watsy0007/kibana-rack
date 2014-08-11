require 'spec_helper'

describe Kibana::Rack::Web do
  include Rack::Test::Methods

  let(:app) { described_class }

  let(:dashboards_path) { File.expand_path('../../../../fixtures/dashboards', __FILE__) }

  before do
    app.set(:raise_exceptions, true)
    app.set(:show_exceptions, false)
    app.set(:kibana_dashboards_path, dashboards_path)
  end

  it 'serves the Kibana application' do
    get '/'
    expect(last_response.status).to eql(200)
  end

  it 'serves the Kibana configuration' do
    get '/config.js'
    expect(last_response.status).to eql(200)
  end

  it 'renders JavaScript dashboards from the dashboard directory' do
    get '/app/dashboard/script/js_dashboard.js'

    expect(last_response.body).to eql(IO.read(File.join(dashboards_path, 'js_dashboard.js')))
    expect(last_response['Content-Type']).to eql('application/js')
    expect(last_response.status).to eql(200)
  end

  it 'renders JSON dashboards from the dashboard directory' do
    get '/app/dashboard/file/json_dashboard.json'

    expect(last_response.body).to eql(IO.read(File.join(dashboards_path, 'json_dashboard.json')))
    expect(last_response['Content-Type']).to eql('application/json')
    expect(last_response.status).to eql(200)
  end

  it 'processes ERB in dashboards' do
    ENV['DASHBOARD_TITLE'] = 'My Dashboard'
    get '/app/dashboard/file/erb_dashboard.json'

    expect(last_response.body.strip).to eql('{"title":"My Dashboard"}')
  end

  it 'returns 404 if a dashboard does not exist' do
    get '/app/dashboard/file/nonexistent.json'

    expect(last_response.body.strip).to eql('{"error":"Not found"}')
    expect(last_response.status).to eql(404)
  end

  {
    '/_aliases'                                         => { method: :get },
    '/_nodes'                                           => { method: :get },
    '/_all/_aliases'                                    => { method: :get },
    '/_all/_mapping'                                    => { method: :get },
    '/_all/_search'                                     => { method: :post, body: '{"j":"s","o":"n"}' },
    '/logstash-2014.08.08,logstash-2014.08.09/_aliases' => { method: :get, params: { ignore_missing: 'true' } }
  }.each do |path, options|
    it "proxies #{options[:method].upcase} #{path} to Elasticsearch" do
      request_method = options[:method]
      stub_request(request_method, "localhost:9200#{path}")
        .with(body: options[:body], query: options[:params])
        .to_return(body: '{}', headers: { 'foo' => 'bar' }, status: 200)

      request_params = request_method == :post ? options[:body] : options[:params]
      send(request_method, path, request_params)

      expect(last_response.body).to eql('{}')
      expect(last_response.status).to eql(200)
      expect(last_response.headers).to include('foo' => 'bar')
    end
  end
end
