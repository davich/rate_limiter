require_relative '../rate_limiter/cache/hash_cache'
require_relative '../rate_limiter/attempt'

module Middleware
  class RateLimiter
    def initialize(app, options = {})
      @app = app
      @cache = options[:cache] || ::RateLimiter::Cache::HashCache.new
    end

    def call(env)
      attempt = ::RateLimiter::Attempt.new(cache: @cache, request: Rack::Request.new(env)).attempt!

      if attempt[:allowed]
        @app.call(env)
      else
        [
          429,
          {'Content-Type' => 'text/plain; charset=utf-8'},
          [attempt[:limited_message]],
        ]
      end
    end
  end
end
