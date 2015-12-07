require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
  end

  it 'should redirect to okta home when logged out' do
    delete :destroy
    expect(response).to redirect_to 'https://dev-774694.oktapreview.com'
    expect(session[:userid]).to be nil
    expect(session[:forward_url]).to be nil
  end

  it 'should redirect to okta home when logged out in staging' do
    Rails.env = 'staging'
    delete :destroy
    expect(response).to redirect_to 'https://dev-846101.oktapreview.com'
    expect(session[:userid]).to be nil
    expect(session[:forward_url]).to be nil
    Rails.env = 'test'
  end
end
