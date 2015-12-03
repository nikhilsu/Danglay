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
  end
end

