# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
  end

  describe 'GET #home' do
    describe 'GET #about' do
      it 'gets the about page' do
        get :about
        expect(response).to render_template('about')
      end
    end

    describe 'GET #contact' do
      it 'gets the contact page' do
        get :contact
        expect(response).to render_template('contact')
      end
    end

    describe 'GET #terms_and_conditions' do
      it 'gets the terms and conditions page' do
        get :terms_and_conditions
        expect(response).to render_template('terms_and_conditions')
      end
    end

    describe 'GET #privacy_policy' do
      it 'gets the privacy policy page' do
        get :privacy_policy
        expect(response).to render_template('privacy_policy')
      end
    end
  end
end
