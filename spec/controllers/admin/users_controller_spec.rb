# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'GET new' do
    before(:each) do
      user = build_stubbed(:user)
      user.role = build_stubbed(:role, :admin_role)
      names = user.name.split(' ')
      session[:FirstName] = names[0]
      session[:LastName] = names[1]
      session[:Email] = user.email
      allow(User).to receive(:find_by_email).and_return(user)
    end

    it 'renders new page' do
      get :new
      expect(response).to render_template('new')
    end

    it 'renders new page on invalid registration' do
      locality_id = build(:locality).id
      post :create, user: { emp_id: 12_345, address: '', locality: locality_id, phone_no: '+91 9080706044' }
      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'renders root url when registration is completed' do
      locality_id = create(:locality).id
      post :create, user: { emp_id: 12_345, address: 'blah', locality: locality_id, phone_no: '+91 9080706044', email: 'balh', name: 'blah' }
      user = assigns(:user)
      allow(user).to receive(:save).and_return(true)
      expect(user.errors.any?).to be false
      expect(response).to redirect_to admin_path
    end
  end
end
