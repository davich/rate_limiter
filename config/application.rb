require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/middleware/rate_limiter'
require_relative '../lib/rate_limiter/cache/db_cache'

module RateLimiter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.middleware.use ::Middleware::RateLimiter, cache: RateLimiter::Cache::HashCache.new

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
