require 'rails_helper'

describe RateLimiter::Attempt do
  describe '#attempt!' do
    let(:cache) { instance_double(RateLimiter::Cache::HashCache, increment: true) }
    let(:request) { instance_double(Rack::Request, ip: ip_address) }
    let(:ip_address) { '127.0.0.255' }

    subject { described_class.new(cache: cache, request: request) }

    before do
      allow(cache).to receive(:get).with(/#{ip_address}\/\d{10}/).and_return(hits)
    end

    context 'limit is exceeded' do
      let(:hits) { 101 }
      it 'is not allowed' do
        expect(subject.attempt!).to include(allowed: false)
      end

      it 'returns limited message' do
        expect(subject.attempt!).to include(limited_message: 'Rate Limit Exceeded')
      end
    end

    context 'limit is not exceeded' do
      let(:hits) { 100 }
      it 'is allowed' do
        expect(subject.attempt!).to include(allowed: true)
      end

      it 'returns limited message' do
        expect(cache).to receive(:increment)
        subject.attempt!
      end
    end
  end
end
