require 'rails_helper'

describe RateLimiter::Attempt do
  describe '#attempt!' do
    let(:cache) { RateLimiter::Cache::HashCache.new }
    let(:request) { instance_double(Rack::Request, ip: ip_address) }
    let(:ip_address) { '127.0.0.255' }

    subject { described_class.new(cache: cache, request: request) }

    before do
      Timecop.freeze(Time.new(2002, 10, 31, 2, 52, 21))
      hits.times do
        subject.attempt!
      end
    end

    after do
      Timecop.return
    end

    context 'limit is exceeded' do
      let(:hits) { 100 }
      it 'is not allowed' do
        expect(subject.attempt!).to include(allowed: false)
      end

      it 'returns limited message' do
        expect(subject.attempt!).to include(limited_message: 'Rate Limit Exceeded. Try again in 459 seconds')
      end

      it 'does not block other users from accessing it' do
        request = instance_double(Rack::Request, ip: '9.9.9.9')
        new_attempt = described_class.new(cache: cache, request: request)
        expect(new_attempt.attempt!).to include(allowed: true)
      end

      it 'resets after 1 hour' do
        Timecop.freeze(Time.now + 1.hour) do
          expect(subject.attempt!).to include(allowed: true)
        end
      end
    end

    context 'limit is not exceeded' do
      let(:hits) { 99 }
      it 'is allowed' do
        expect(subject.attempt!).to include(allowed: true)
      end

      it 'increments the cache' do
        expect(cache).to receive(:increment)
        subject.attempt!
      end
    end
  end
end
