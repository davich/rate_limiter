module RateLimiter
  module Cache
    class DbCache
      def increment(key)
        limit = Limit.find_or_create_by(key: key) do |limit|
          limit.hits = 0
        end

        limit.increment!
      end

      def get(key)
        Limit.where(key: key).first&.hits || 0
      end
    end
  end
end
