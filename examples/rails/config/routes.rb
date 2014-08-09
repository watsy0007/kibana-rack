Rails.application.routes.draw do
  mount Kibana::Rack::Web => '/kibana'
end
