require 'rails_helper'

RSpec.describe CabpoolsHelper, type: :helper do

  include SessionsHelper

  it 'should return time in proper format for AM' do
    cabpool = build(:cabpool, :time_in_am)
    expect(formatted_time(cabpool.timeout)).to eq '09:30 AM'
  end

  it 'should return time in proper format for PM' do
    cabpool = build(:cabpool, :time_in_pm)
    expect(formatted_time(cabpool.timeout)).to eq '10:30 PM'
  end

  it 'should return time in proper format for midnight times' do
    cabpool = build(:cabpool, timeout: '00:01')
    expect(formatted_time(cabpool.timeout)).to eq '12:01 AM'
  end

  it 'should return time in proper format for afternoon times' do
    cabpool = build(:cabpool, timeout: '12:01')
    expect(formatted_time(cabpool.timeout)).to eq '12:01 PM'
  end

  it "should return false when user is not registered" do
    cabpool = build(:cabpool)
    expect(requested_user?(cabpool)).to be false
  end

  it 'should return false when user has requested for a particular cab pool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    allow(User).to receive(:find_by_email).and_return(user)
    expect(requested_user?(cabpool)).to be false
  end

  it 'should return true when user has requested for a particular cab pool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    request = build(:request)
    user.requests = [request]
    user.requested_cabpools = [cabpool]
    allow(User).to receive(:find_by_email).and_return(user)
    expect(requested_user?(cabpool)).to be true
  end

  it 'should return destination as Koramangala' do
    expect(destination).to eq 'Koramangala'
  end

  it 'should return the current user\'s cabpool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    expect(users_cabpool).to be cabpool
  end

  it 'should return the current true if current users cabpool exists' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_cabpool_exists?).to be true
  end

  it 'should return the current false if current users cabpool does not exist' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_cabpool_exists?).to be false
  end

  it "should render all cabpools except the current users cabpool " do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    expect(cabpools_to_render(Cabpool.all)).to_not include cabpool
  end

  it "should render all cabpools if current user has no cabpool" do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    allow(Cabpool).to receive(:all).and_return([cabpool])
    expect(cabpools_to_render(Cabpool.all)).to include cabpool
  end

  it "should return requested cabpool of current user" do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    user.requested_cabpools = [cabpool]
    allow(User).to receive(:find_by_email).and_return(user)
    expect(users_requested_cabpool).to be cabpool
  end

  it 'should return true if current user has requested for cabpool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    user.requested_cabpools = [cabpool]
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_requested_cabpool_exists?).to be true
  end

  it 'should return false if current user has not requested for cabpool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_requested_cabpool_exists?).to be false
  end

  it "should render all cabpools except the requested cabpool" do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    cabpool = build(:cabpool)
    user.requested_cabpools = [cabpool]
    allow(User).to receive(:find_by_email).and_return(user)
    expect(cabpools_to_render(Cabpool.all)).to_not include cabpool
  end

  it 'should return join as the button to be shown if user is not registered' do
    cabpool = double()
    session.delete(:registered_uid)
    expect(button(cabpool)).to eq "Join"
  end

  it 'should return requested as the button to be shown if cabpool is requested by user' do
    cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([cabpool])
    expect(button(cabpool)).to eq "Requested"
  end

  it 'should return leave button if user is of the same cabpool' do
    cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    allow(current_user).to receive(:cabpool).and_return(cabpool)
    allow(cabpool).to receive(:available_slots).and_return(2)
    expect(button(cabpool)).to eq "Leave"
  end

  it 'should return no button if cabpool has no available slots' do
    cabpool = double()
    another_cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    allow(current_user).to receive(:cabpool).and_return(another_cabpool)
    allow(cabpool).to receive(:available_slots).and_return(0)
    expect(button(cabpool)).to eq nil
  end

  it 'should return no button if user has existing requests' do
    cabpool = double()
    two_cabpool = double()
    three_cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([three_cabpool])
    allow(current_user).to receive(:cabpool).and_return(two_cabpool)
    allow(cabpool).to receive(:available_slots).and_return(2)
    expect(button(cabpool)).to eq nil
  end

  it 'should show join button when current user has no requests, has another assigned cabpool, and available slots present' do
    cabpool = double()
    two_cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    allow(current_user).to receive(:cabpool).and_return(two_cabpool)
    allow(cabpool).to receive(:available_slots).and_return(2)
    expect(button(cabpool)).to eq "Join"
  end
end
