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

  it 'should return false when user has not requested for cab pool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    expect(requested_user?(cabpool)).to be false
  end

  it 'should return false when user has not requested for a particular cab pool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    user.status = 'Requested'
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    another_cabpool = build(:cabpool)
    expect(requested_user?(another_cabpool)).to be false
  end

  it 'should return true when user has requested for a particular cab pool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    session[:registered_uid] = 1
    user.status = 'Requested'
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    expect(requested_user?(cabpool)).to be true
  end
end
