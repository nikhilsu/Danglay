require 'rails_helper'

RSpec.describe CabpoolsHelper, type: :helper do

  include SessionsHelper
  include ApplicationHelper

  user = nil

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:registered_uid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
  end

  it 'should return true if the current user is an admin' do
    role = build_stubbed(:role, :admin_role)
    user.role = role
    allow(User).to receive(:find_by).and_return(user)

    expect(is_admin?).to be true
  end
end