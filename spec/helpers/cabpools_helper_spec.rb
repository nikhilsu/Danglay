require 'rails_helper'

RSpec.describe CabpoolsHelper, type: :helper do

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

  it 'should return destination as Kormangala' do
    expect(destination).to eq 'Kormangala'
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
    expect(cabpools_to_render).to_not include(cabpool)
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
    allow(Cabpool).to receive(:all).and_return(cabpool)
    expect(cabpools_to_render).to be cabpool
  end
end
