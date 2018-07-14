module RateLimiter
  class Attempt
    def initialize(cache:, request:)
      @cache = cache
      @request = request
    end

    def attempt!
      if limit_exceeded?
        { allowed: false, limited_message: 'Rate Limit Exceeded' }
      else
        @cache.increment(key)
        { allowed: true }
      end
    end

    private

    def limit_exceeded?
      @cache.get(key) >= 100
    end

    def key
      "#{@request.ip}/#{Time.now.strftime('%Y%m%d%H')}"
    end
  end
end
