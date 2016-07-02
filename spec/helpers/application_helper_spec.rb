# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CabpoolsHelper, type: :helper do
  include SessionsHelper
  include ApplicationHelper

  user = nil

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
  end

  it 'returns zero when the status of the current is nil and he/she does not belong to a cabpool' do
    user = build(:user)
    user.cabpool = nil
    user.status = nil
    allow(User).to receive(:find_by).and_return(user)

    expect(number_of_notifications).to eq 0
  end

  it 'returns current users cabpools requested users number if user status is nil' do
    user = build(:user)
    cabpool = build(:cabpool)
    cabpool.requested_users = [user]
    user.cabpool = cabpool
    allow(User).to receive(:find_by).and_return(user)

    expect(number_of_notifications).to eq 1
  end

  it 'returns current users cabpools requested users number plus 1 if user status is not nil' do
    user = build(:user)
    cabpool = build(:cabpool)
    cabpool.requested_users = [user]
    user.cabpool = cabpool
    user.status = 'approved'
    allow(User).to receive(:find_by).and_return(user)

    expect(number_of_notifications).to eq 2
  end

  it 'should return base_title when page title is blank' do
    expect(full_title).to eq 'Danglay App'
  end

  it "should return page title with base title when page title is not blank" do
    page_title = 'My Ride'
    expect(full_title page_title).to eq "#{page_title} | Danglay App"
  end
end
