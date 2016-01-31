require 'rails_helper'

RSpec.describe CustomErrorsController, type: :controller do

  include SessionsHelper

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:registered_uid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    ActionMailer::Base.deliveries.clear
  end

  it 'should render not_found_error page with a 404 status when page_not_found' do
    get :page_not_found

    expect(response).to have_http_status(404)
    expect(response).to render_template("not_found_error")
  end

  it 'should render internal_server_error page with a 500 status when server_error' do
    get :server_error

    expect(response).to have_http_status(500)
    expect(response).to render_template("internal_server_error")
    expect(response).to render_template(layout: "layouts/error")
  end
end
