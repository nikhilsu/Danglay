require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  it 'should set username when the user is logged in' do
    session[:Email] = 'userLoggedIn@mail.com'
    session[:FirstName] = 'first name'

    expect(@controller.set_user_name).to eq 'First name'
  end

  it 'should not set username when the user is not logged in' do
    session[:Email] = nil
    session[:FirstName] = 'first name'

    expect(@controller.set_user_name).to be nil
  end

  it 'should check if a feature is activated' do
    controller_name = 'Some Controller'
    action_name = 'Some Action'

    expect_any_instance_of(ActionController::Parameters).to receive(:[]).with(:controller).and_return(controller_name)
    expect_any_instance_of(ActionController::Parameters).to receive(:[]).with(:action).and_return(action_name)
    expect(FEATURES).to receive(:active_action?).with(controller_name, action_name).once

    @controller.check_feature_activated?
  end
end