require 'rails_helper'

describe HomeController, type: :controller do
  describe 'GET index' do
    it 'returns ok' do
      get :index
      expect(response.body).to eq('ok')
    end
  end
end
