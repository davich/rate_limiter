require 'rails_helper'
require 'rack/test'

OUTER_APP = Rack::Builder.parse_file("config.ru").first

describe HomeController, type: :controller do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  describe 'GET index' do
    it 'returns ok' do
      get '/home'
      expect(last_response.body).to eq('ok')
    end

    context 'on the 101st request (within an hour)' do
      before(:all) do
        100.times do |i|
          get '/home'
          expect(last_response.status).to eq(200)
        end

        get '/home'
      end

      it 'returns status 429' do
        expect(last_response.status).to eq(429)
      end

      it 'returns Rate Limit Exceeded' do
        expect(last_response.body).to eq('Rate Limit Exceeded')
      end
    end
  end
end
