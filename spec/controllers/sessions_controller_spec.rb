require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:each) do
    session[:userid] = create(:user).id
  end

  it 'should redirect to okta home when logged out' do
    delete :destroy
    expect(response).to redirect_to 'https://dev-774694.oktapreview.com'
    expect(session[:userid]).to be nil
  end
end
