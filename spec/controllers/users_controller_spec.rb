require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET new' do
    before(:each) do
      session[:userid] = 1
    end

    it 'should render new page' do
      get :new
      expect(response).to render_template('new')
    end

    it 'should render new page on invalid signup with blank address' do
      locality_id = create(:locality).id
      post :create, :user => { name: 'User', emp_id: 12345, email: 'user@example', address: '', locality: locality_id }
      user = assigns(:user)
      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'should render new page on invalid signup with blank locality' do
      post :create, :user => { name: 'User', emp_id: 12345, email: 'user@example', address: 'Address', locality: '-1' }
      user = assigns(:user)
      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'should render show page on valid signup with new locality' do
      before_count = Locality.count
      post :create, :user => { name: 'User', emp_id: 12345, email: 'user@example', address: 'Address', locality: '-1', other: 'New Locality' }
      after_count = Locality.count
      user = assigns(:user)
      expect(response).to redirect_to(user)
      expect(user.errors.any?).to be false
      expect(after_count - before_count).to eq 1
    end

    it 'should render show page on valid signup' do
      locality_id = create(:locality).id
      post :create, :user => { name: 'User', emp_id: 12345, email: 'user@example', address: 'Address', locality: locality_id }
      user = assigns(:user)
      expect(response).to redirect_to(user)
      expect(user.errors.any?).to be false
    end

  end
end