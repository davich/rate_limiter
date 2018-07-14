module RateLimiter
  class Attempt
    def initialize(cache:, request:)
      @cache = cache
      @request = request
    end

    def attempt!
      if limit_exceeded?
        {
          allowed: false,
          limited_message: "Rate Limit Exceeded. Try again in #{seconds_until_next_hour} seconds"
        }
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

    def seconds_until_next_hour
      x = Time.parse(Time.now.strftime('%Y-%m-%d %H:00')) + 1.hour
      (x - Time.now).floor
    end
  end
end
