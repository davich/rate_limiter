require 'rails_helper'
require 'rack/test'

OUTER_APP = Rack::Builder.parse_file("config.ru").first

describe HomeController, type: :controller do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  describe 'GET index' do
    def get_home(ip_address='127.0.0.1')
      get '/home', {}, 'REMOTE_ADDR' => ip_address
    end

    it 'returns ok' do
      get '/home'
      expect(last_response.body).to eq('ok')
    end

    context 'on the 101st request (within an hour)' do
      before(:all) do
        ip_address = '127.0.0.5'
        100.times do
          get_home(ip_address)
          expect(last_response.status).to eq(200)
        end

        get_home(ip_address)
      end

      it 'returns status 429' do
        expect(last_response.status).to eq(429)
      end

      it 'returns Rate Limit Exceeded message' do
        expect(last_response.body).to match(/Rate Limit Exceeded. Try again in \d+ seconds/)
      end
    end
  end
end
