require 'spec_helper'

describe Kibana::Rack::Web do
  include Rack::Test::Methods

  KIBANA_INDEX = 'test-int'
  let(:app) { described_class }
  let(:dashboards_path) { File.expand_path('../../../../fixtures/dashboards', __FILE__) }

  before do
    app.set(:raise_exceptions, true)
    app.set(:show_exceptions, false)
    app.set(:kibana_dashboards_path, dashboards_path)
    app.set(:kibana_index, KIBANA_INDEX)
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
    get '/app/dashboards/js_dashboard.js'

    expect(last_response.body).to eql(IO.read(File.join(dashboards_path, 'js_dashboard.js')))
    expect(last_response['Content-Type']).to eql('application/js')
    expect(last_response.status).to eql(200)
  end

  it 'renders JSON dashboards from the dashboard directory' do
    get '/app/dashboards/json_dashboard.json'

    expect(last_response.body).to eql(IO.read(File.join(dashboards_path, 'json_dashboard.json')))
    expect(last_response['Content-Type']).to eql('application/json')
    expect(last_response.status).to eql(200)
  end

  it 'processes ERB in dashboards' do
    ENV['DASHBOARD_TITLE'] = 'My Dashboard'
    get '/app/dashboards/erb_dashboard.json'

    expect(last_response.body.strip).to eql('{"title":"My Dashboard"}')
  end

  it 'returns 404 if a dashboard does not exist' do
    get '/app/dashboards/nonexistent.json'

    expect(last_response.body.strip).to eql('{"error":"Not found"}')
    expect(last_response.status).to eql(404)
  end

  [
    %w(put /_cluster/settings),
    %w(post /_shutdown),
    %w(post /_cluster/nodes/_shutdown),
    %w(delete /*),
    %w(delete /_all),
    %w(delete /_all/_query?q=*),
    %w(delete /logstash-2014.08.08/_query?q=*),
    %w(delete /logstash-2014.08.08),
    %w(post /logstash-2014.08.08),
    %w(put /logstash-2014.08.08/message/123),
    %w(post /logstash-2014.08.08/message/123/_update),
    %w(get /logstash-2014.08.08/dashboard/123),
    %w(get /logstash-2014.08.08/temp/123)
  ].each do |method, path|
    it "should prevent #{method.upcase} #{path} being proxied to Elasticsearch" do
      send(method, path)

      expect(last_response.body.strip).to eql('<h1>Not Found</h1>')
      expect(last_response.status).to eql(404)
    end
  end

  {
    '/_aliases'                                         => { method: :get },
    '/_nodes'                                           => { method: :get },
    '/_all/_aliases'                                    => { method: :get },
    '/_all/_mapping'                                    => { method: :get },
    '/_all/_search'                                     => { method: :post, body: '{"j":"s","o":"n"}' },
    '/logstash-2014.08.08,logstash-2014.08.09/_aliases' => { method: :get, params: { ignore_missing: 'true' } },
    "/#{KIBANA_INDEX}/temp?ttl=30d"                     => { method: :post, body: '{"j":"s","o":"n"}' },
    "/#{KIBANA_INDEX}/temp/GjO0MfT5QL6dLqOytd6qDw"      => { method: :get, params: { cache: 123 } },
    "/#{KIBANA_INDEX}/dashboard/read_example"           => { method: :get, params: { cache: 123 } },
    "/#{KIBANA_INDEX}/dashboard/write_example"          => { method: :put, body: '{"j":"s","o":"n"}' }
  }.each do |path, options|
    it "proxies #{options[:method].upcase} #{path} to Elasticsearch" do
      request_method = options[:method]
      stub_request(request_method, "localhost:9200#{path}")
        .with(body: options[:body], query: options[:params])
        .to_return(body: '{}', headers: { 'foo' => 'bar' }, status: 200)

      request_params = options[:body] || options[:params]
      send(request_method, path, request_params)

      expect(last_response.body).to eql('{}')
      expect(last_response.status).to eql(200)
      expect(last_response.headers).to include('foo' => 'bar')
    end
  end
end
