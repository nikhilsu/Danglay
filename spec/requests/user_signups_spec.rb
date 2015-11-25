require 'rails_helper'

RSpec.describe "UserSignups", type: :request do
  describe 'user signup' do

    it 'sign up with empty address should throw error' do
      get signup_path
      expect(response).to render_template(:new)
      locality_id = create(:locality).id

      post '/users', :user => { name: 'User', emp_id: 12345, email: 'user@example', address: '', locality: locality_id }
      expect(response).to render_template(:new)
      expect(response.body).to include 'error'
    end

    it 'sign up with valid user' do
      get signup_path
      expect(response).to render_template(:new)
      locality_id = create(:locality).id

      post '/users', :user => { name: 'User', emp_id: 12345, email: 'user@example', address: 'Address', locality: locality_id }
      follow_redirect!
      expect(response).to render_template(:show)
    end
  end
end
