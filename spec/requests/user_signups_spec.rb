require 'rails_helper'

RSpec.describe "UserSignups", type: :request do
  describe 'user signup' do
    it 'sign up with empty address should throw error' do
      get signup_path
      expect(response).to render_template(:new)
      locality_name = build(:locality).name

      post '/users', :user => { address: '', locality: locality_name }
      expect(response).to render_template(:new)
      expect(response.body).to include 'error'
    end
  end
end
