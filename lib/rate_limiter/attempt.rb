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
          try_again_seconds: seconds_until_next_hour,
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
      "#{@request.ip}/#{DateTime.now.strftime('%Y%m%d%H')}"
    end

    def seconds_until_next_hour
      next_hour = DateTime.now.beginning_of_hour + 1.hour
      diff_in_seconds = (next_hour - DateTime.now) * 1.days
      diff_in_seconds.to_i
    end
  end
end
