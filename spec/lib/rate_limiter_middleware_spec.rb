require 'rails_helper'

describe RateLimiterMiddleware do
  let(:app) { ->(env) { [200, env, "ok"] } }
  let(:middleware) { described_class.new(app) }

  it 'allows the call to pass through' do
    code, env = middleware.call(Rack::MockRequest.env_for('http://domain.com'))
    expect(code).to eq(200)
    puts env.inspect
  end
end
