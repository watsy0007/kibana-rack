Rails.application.configure do
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
end
