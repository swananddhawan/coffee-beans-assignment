Sidekiq.configure_server do |config|
  # config.redis = { url: 'redis://localhost:6379/0' } # Redis server configuration
  # TODO: Put this in environment
  config.redis = { url: 'redis://localhost:6379/0' } # Redis server configuration
end

Sidekiq.configure_client do |config|
  # config.redis = { url: 'redis://localhost:6379/0' } # Redis server configuration
  # TODO: Put this in environment
  config.redis = { url: 'redis://localhost:6379/0' } # Redis server configuration
end
