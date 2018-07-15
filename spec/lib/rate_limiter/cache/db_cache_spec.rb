require 'rails_helper'

describe RateLimiter::Cache::DbCache do
  describe '#increment' do
    let(:key) { 'abc123' }

    it 'increments the cache' do
      expect do
        subject.increment(key)
      end.to change { subject.get(key) }.from(0).to(1)
    end

    it 'only increments the specific key' do
      subject.increment(key)
      expect do
        subject.increment('other_key1')
        subject.increment('other_key2')
      end.to_not change { subject.get(key) }
    end
  end
end
