require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET new' do

    before(:each) do
      user = build_stubbed(:user)
      names = user.name.split(' ')
      session[:userid] = user.id
      session[:FirstName] = names[0]
      session[:LastName] = names[1]
      session[:Email] = user.email
    end

    it 'should redirect to create saml request when session is not set' do
      session.delete(:userid)
      get :new
      expect(response).to redirect_to('/saml/init')
    end

    it 'should render new page' do
      get :new

      expect(response).to render_template('new')
    end

    it 'should render new page on invalid signup with blank address' do
      locality_id = create(:locality).id
      post :create, :user => {emp_id: 12345, address: '', locality: locality_id }
      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'should render new page on invalid signup with blank locality' do
      post :create, :user => { emp_id: 12345, address: 'Address', locality: '-1' }
      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'should render new page on invalid signup with correct new locality but other errors' do
      post :create, :user => { emp_id: 12345, address: '', locality: '-1', other: 'New Locality' }
      user = assigns(:user)

      expect(user.save).to be false
      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'should render new page on invalid signup with new locality which already exists' do
      locality = create(:locality)
      post :create, :user => { emp_id: 12345, address: 'Address', locality: '-1', other: locality.name }

      user = assigns(:user)

      expect(user.save).to be false
      expect(response).to render_template('new')
      expect(user.errors.any?).to be true
    end

    it 'should render new page on invalid signup with correct new locality but other errors' do
      post :create, :user => { name: 'User', emp_id: 12345, email: 'user@example', address: '', locality: '-1', other: 'New Locality' }

      user = assigns(:user)

      expect(response).to render_template('new')
      expect(user.save).to be false
      expect(user.errors.any?).to be true
    end

    it 'should render show page while logged in' do
      user = create(:user)
      get :show, { id: user.id }

      expect(response).to render_template('show')
    end

    it 'should have preset name and email from okta response' do
      get :new
      user = assigns(:user)

      expect(user.name).to eq(session[:FirstName] + ' ' + session[:LastName])
      expect(user.email).to eq(session[:Email])
    end

    it "should set registered user id for a valid user signup" do
      post :create, :user => { emp_id: 12345, address: 'Address', locality: '-1', other: 'New Locality' }
      user = assigns(:user)

      expect(session[:registered_uid]).to be user.id
    end

    it "should not allow to registered user to register again" do
      session[:registered_uid] = 1
      get :new
      expect(response).to redirect_to root_path
    end

    it "should friendly redirect on new user creation" do
      session[:forward_url] = '/cabpool/new'

      post :create, :user => { emp_id: 12345, address: 'Address', locality: '-1', other: 'New Locality' }
      expect(response).to redirect_to '/cabpool/new'
    end

  end
end