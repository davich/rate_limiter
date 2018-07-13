class RateLimiterMiddleware
  def initialize(app, options = {})
    @app = app
    @cache = options[:cache] || RateLimiterCache::HashCache.new
  end

  def call(env)
    request = build_request(env)
    if limit_exceeded?(request)
      [
        429,
        {'Content-Type' => 'text/plain; charset=utf-8'},
        ["Rate Limit Exceeded"],
      ]
    else
      @cache.increment(key(request))
      @app.call(env)
    end
  end

  private

  def limit_exceeded?(request)
    @cache.get(key(request)) > 100
  end

  def key(request)
    request.ip.to_s
  end

  def build_request(env)
    Rack::Request.new(env)
  end
end
