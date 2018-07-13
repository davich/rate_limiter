module RateLimiterCache
  class HashCache
    def initialize
      @state = Hash.new(0)
    end

    def increment(key)
      @state[key] += 1
    end

    def get(key)
      @state[key]
    end
  end
end
