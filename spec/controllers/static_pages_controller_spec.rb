require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email

  end

  describe 'GET #home' do
    it 'should get the home page' do
      get :home
      expect(response).to render_template('home')
    end

    describe 'GET #about' do
      it 'should get the about page' do
        get :about
        expect(response).to render_template('about')
      end
    end

    describe 'GET #contact' do
      it 'should get the contact page' do
        get :contact
        expect(response).to render_template('contact')
      end
    end

    it 'render home page with filtered results post to show' do
      cabpool = build(:cabpool, :without_localities)
      locality = create(:locality, name: Faker::Address.street_name)
      cabpool.localities << locality
      locality.cabpools << cabpool
      post :show, localities: { locality_id: locality.id }
      expect(response).to render_template('home')
      expect(flash.empty?).to be true
    end

    it 'render home page with all cabpools and flash if no cabs for searched locality' do
      cabpool = build(:cabpool, :without_localities)
      locality = Locality.create(name: Faker::Address.street_address)
      cabpool.localities << locality
      post :show, localities: { locality_id: locality.id }
      expect(response).to render_template('home')
      expect(flash[:danger]).to eq "Locality has no cabpools"
    end

    it 'render home page with all cabpools and flash if no locality selected' do
      cabpool = build(:cabpool)
      post :show, localities: { locality_id: '' }
      expect(response).to render_template('home')
      expect(flash[:danger]).to eq "Select a locality"
    end
  end
end
