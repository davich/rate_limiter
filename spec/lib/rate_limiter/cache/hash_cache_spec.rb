require 'rails_helper'

describe RateLimiter::Cache::HashCache do
  describe '#increment' do
    let(:key) { 'abc123' }

    it 'increments the cache' do
      expect do
        subject.increment(key)
      end.to change { subject.get(key) }.from(0).to(1)
    end
  end
end
