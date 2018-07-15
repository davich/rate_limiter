require 'rails_helper'

describe Middleware::RateLimiter do
  let(:app) { ->(env) { [200, env, "ok"] } }
  let(:middleware) { described_class.new(app, cache: cache) }
  let(:cache) { RateLimiter::Cache::HashCache.new }

  describe '#call' do
    subject { middleware.call(Rack::MockRequest.env_for('http://domain.com')) }

    it 'allows the call to pass through' do
      code, env = subject
      expect(code).to eq(200)
    end

    context 'limit exceeded' do
      before do
        allow(cache).to receive(:get).and_return(100)
      end

      it 'returns 429' do
        code, env = subject
        expect(code).to eq(429)
      end

      it 'returns the message' do
        code, env, message = subject
        expect(message.first).to match(/Rate Limit Exceeded. Try again in \d+ seconds/)
      end
    end
  end
end
