Rails.application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :info
  config.serve_static_assets = false
  config.action_controller.perform_caching = true
  config.active_support.deprecation = :notify
end
