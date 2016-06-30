# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  emp_id      :integer
#  name        :string
#  email       :string
#  address     :text
#  locality_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cabpool_id  :integer
#  status      :string
#  phone_no    :string
#  role_id     :integer
#
# Indexes
#
#  index_users_on_cabpool_id   (cabpool_id)
#  index_users_on_emp_id       (emp_id) UNIQUE
#  index_users_on_locality_id  (locality_id)
#  index_users_on_role_id      (role_id)
#
# Foreign Keys
#
#  fk_rails_43d6d9310b  (cabpool_id => cabpools.id)
#  fk_rails_642f17018b  (role_id => roles.id)
#  fk_rails_67d309e01c  (locality_id => localities.id)
#

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET new' do
    before(:each) do
      user = build_stubbed(:user)
      names = user.name.split(' ')
      session[:FirstName] = names[0]
      session[:LastName] = names[1]
      session[:Email] = user.email
    end

    it 'redirects to create saml request when session is not set' do
      session.clear
      get :new
      expect(response).to redirect_to('/saml/init')
    end

    it 'renders new page' do
      get :new

      expect(response).to render_template('new')
    end

    it 'renders new page on invalid signup with blank address' do
      locality_id = create(:locality).id
      post :create, user: { emp_id: 12_345, address: '', locality: locality_id, phone_no: '+91 9080706044' }
      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'renders new page on invalid signup with blank phone no' do
      locality_id = create(:locality).id
      post :create, user: { emp_id: 12_345, address: 'Address', locality: locality_id, phone_no: '' }
      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'renders new page on invalid signup with blank locality' do
      post :create, user: { emp_id: 12_345, address: 'Address', locality: '-1', phone_no: '+91 9080706044' }
      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'renders new page on invalid signup with correct new locality but other errors' do
      post :create, user: { emp_id: 12_345, address: '', locality: '-1', other: 'New Locality', phone_no: '+91 9080706044' }
      user = assigns(:user)

      expect(user.save).to be false
      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'renders new page on invalid signup with new locality which already exists' do
      locality = create(:locality)
      post :create, user: { emp_id: 12_345, address: 'Address', locality: '-1', other: locality.name, phone_no: '+91 9080706044' }

      user = assigns(:user)

      expect(user.save).to be false
      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'renders new page on invalid signup with correct new locality but other errors' do
      post :create, user: { name: 'User', emp_id: 12_345, email: 'user@example', address: '', locality: '-1', other: 'New Locality', phone_no: '+91 9080706044' }

      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.save).to be false
      expect(user.errors.any?).to be true
    end

    it 'renders show page while logged in' do
      user = create(:user)
      get :show, id: user.id

      expect(response).to render_template('show')
    end

    it 'has preset name and email from okta response' do
      get :new
      user = assigns(:user)

      expect(user.name).to eq(session[:FirstName] + ' ' + session[:LastName])
      expect(user.email).to eq(session[:Email])
    end

    it 'does not allow to registered user to register again' do
      user = build(:user)
      allow(User).to receive(:find_by_email).and_return(user)
      get :new
      expect(response).to redirect_to root_path
    end

    it 'friendlies redirect on new user creation' do
      session[:forward_url] = '/cabpool/new'

      post :create, user: { emp_id: 12_345, address: 'Address', locality: '-1', other: 'New Locality', phone_no: '+91 9080706044' }
      expect(response).to redirect_to '/cabpool/new'
    end

    it 'renders edit profile page' do
      get :edit

      expect(response).to render_template('edit')
    end

    it 'renders edit profile page if there are errors while editing profile' do
      post :create, user: { emp_id: 12_345, address: 'Address', locality: '-1', other: 'New Locality', phone_no: '+91 9080706044' }
      user = assigns(:user)

      get :edit, id: user.id
      patch :update, id: user.id, user: { emp_id: 12_345, address: ' ', locality: '-1', other: '', phone_no: 'abc' }
      user = assigns(:user)

      expect(user.errors.any?).to be true
    end

    it 'renders home page if there are no errors while editing profile' do
      post :create, user: { emp_id: 12_345, address: 'Address', locality: '-1', other: 'New Locality', phone_no: '+91 9080706044' }
      user = assigns(:user)

      expect(user.address).to eq 'Address'

      get :edit, id: user.id
      patch :update, id: user.id, user: { emp_id: 12_345, address: 'Some New Address', locality: '1', phone_no: '9736484247' }
      user = assigns(:user)

      expect(user.address).to eq 'Some New Address'
      expect(user.errors.any?).to be false
      expect(response).to redirect_to(root_url)
    end
  end
end
