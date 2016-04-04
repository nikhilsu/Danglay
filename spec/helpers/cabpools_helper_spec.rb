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
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    cabpool = build(:cabpool)
    allow(User).to receive(:find_by_email).and_return(user)
    expect(requested_user?(cabpool)).to be false
  end

  it 'should return true when user has requested for a particular cab pool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
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
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    expect(users_cabpool).to be cabpool
  end

  it 'should return the current true if current users cabpool exists' do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_cabpool_exists?).to be true
  end

  it 'should return the current false if current users cabpool does not exist' do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_cabpool_exists?).to be false
  end

  it "should render all cabpools except the current users cabpool " do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    users_cabpool = Cabpool.first
    user.cabpool = users_cabpool
    allow(User).to receive(:find_by_email).and_return(user)

    expect(cabpools_to_render(Cabpool.all)).to_not include users_cabpool
  end

  it "should render all cabpools if current user has no cabpool" do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    all_cabpools = Cabpool.all

    expect(cabpools_to_render(all_cabpools)).to eq all_cabpools
  end

  it "should return requested cabpool of current user" do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    cabpool = build(:cabpool)
    user.requested_cabpools << cabpool
    allow(User).to receive(:find_by_email).and_return(user)
    expect(users_requested_cabpool).to be user.requested_cabpools
  end

  it 'should return true if current user has requested for cabpool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    cabpool = build(:cabpool)
    user.requested_cabpools = [cabpool]
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_requested_cabpool_exists?).to be true
  end

  it 'should return false if current user has not requested for cabpool' do
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    expect(user_requested_cabpool_exists?).to be false
  end

  it 'should return false if user has not received response for his/her cabpool request' do
    user = build(:user)
    names = user.name.split(' ')
    user.status = nil
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)

    expect(received_response_for_cabpool_request?).to be false
  end

  it 'should return true if user has received response for his/her cabpool request' do
    user = build(:user)
    names = user.name.split(' ')
    user.status = 'approved'
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)

    expect(received_response_for_cabpool_request?).to be true
  end

  it 'should return no button if user is not registered and no available slots' do
    cabpool = double()
    @current_user = nil
    session.delete(:Email)
    allow(cabpool).to receive(:available_slots).and_return(0)
    expect(button(cabpool)).to eq nil
  end

  it 'should show Join button if user is not registered and 2 available slots' do
    cabpool = double()
    @current_user = nil
    session.delete(:Email)
    allow(cabpool).to receive(:available_slots).and_return(2)
    expect(button(cabpool)).to eq "Join Ride"
  end

  it 'should return requested as the button to be shown if cabpool is requested by user' do
    cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([cabpool])
    expect(button(cabpool)).to eq "Requested"
  end

  it 'should return leave button if user is of the same cabpool' do
    cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    allow(current_user).to receive(:cabpool).and_return(cabpool)
    allow(cabpool).to receive(:available_slots).and_return(2)
    expect(button(cabpool)).to eq "Leave Ride"
  end

  it 'should return no button if cabpool has no available slots' do
    cabpool = double()
    another_cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    allow(current_user).to receive(:cabpool).and_return(another_cabpool)
    allow(cabpool).to receive(:available_slots).and_return(0)
    expect(button(cabpool)).to eq nil
  end

  it 'should return join button if user has multiple requests' do
    cabpool = double()
    two_cabpool = double()
    three_cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([three_cabpool])
    allow(current_user).to receive(:cabpool).and_return(two_cabpool)
    allow(cabpool).to receive(:available_slots).and_return(2)
    expect(button(cabpool)).to eq "Join Ride"
  end

  it 'should show join button when current user has no requests, has another assigned cabpool, and available slots present' do
    cabpool = double()
    two_cabpool = double()
    user = build(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by_email).and_return(user)
    allow(user).to receive(:requested_cabpools).and_return([])
    allow(current_user).to receive(:cabpool).and_return(two_cabpool)
    allow(cabpool).to receive(:available_slots).and_return(2)
    expect(button(cabpool)).to eq "Join Ride"
  end

  it 'should return tw.png when cabpool is of type company provided cab' do
    cabpool = build(:cabpool)
    cabpool.cabpool_type_id = 1

    expect(image_to_be_displayed(cabpool)).to eq "tw.png"
  end

  it 'should return ola.png when cabpool is of type external cab' do
    cabpool = build(:cabpool)
    cabpool.cabpool_type_id = 2

    expect(image_to_be_displayed(cabpool)).to eq "ola.png"
  end

  it 'should return carpool.png when cabpool is of type own cab cab' do
    cabpool = build(:cabpool)
    cabpool.cabpool_type_id = 3

    expect(image_to_be_displayed(cabpool)).to eq "carpool.png"
  end

  it 'should return a list of cabpool types without Company provided cabpool' do
    personal_car = CabpoolType.new(name: 'Personal Car')
    external_cab = CabpoolType.new(name: 'External cab')
    company_provide_cab = CabpoolType.new(name: 'Company provided Cab')
    all_cabpool_types = [personal_car, external_cab, company_provide_cab]
    cabpool_types_without_company_provide_cab = [personal_car, external_cab]
    allow(CabpoolType).to receive(:all).and_return(all_cabpool_types)

    expect(cabpool_types_for_user).to eq cabpool_types_without_company_provide_cab
  end

  it 'should sort cabpools based on descending order of available slots' do
    cabpool = build(:cabpool)
    another_cabpool = build(:cabpool, :without_users)
    cabpools = [cabpool, another_cabpool]

    cabpools = sort_by_available_slots cabpools

    expect(cabpools).to eq [another_cabpool,cabpool]
  end

  it 'should return false when cabpool type is company provided' do
    cabpool = build(:cabpool)
    cabpool.cabpool_type = build(:cabpool_type, :company_provided_cab)

    expect(is_not_a_company_provided_cabpool? cabpool).to be false
    end

  it 'should return true when cabpool type is not company provided' do
    cabpool = build(:cabpool)
    cabpool.cabpool_type = build(:cabpool_type, :personal_car)

    expect(is_not_a_company_provided_cabpool? cabpool).to be true
  end

  it 'should return appropriate confirm message when user raises a join request and he is part of a pool' do
    user = build(:user)
    names = user.name.split(' ')
    cabpool = build(:cabpool)
    user.cabpool = cabpool
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by).and_return(user)

    expect(confirm_message_for_the_current_users_join_request cabpool).to eq "Are you sure you want to join this cabpool? Confirming would mean that you would be taken out of your existing cabpool if your request is accepted."
  end

  it 'should return appropriate confirm message when user raises a join request and he is part of a pool which has no users' do
    user = build(:user)
    names = user.name.split(' ')
    cabpool = build(:cabpool, :without_users)
    cabpool.users = [user]
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by).and_return(user)
    expect(confirm_message_for_the_current_users_join_request cabpool).to eq "Are you sure you want to join this cabpool? Confirming would mean that your existing cabpool will be deleted if your request is accepted."
  end

  it 'should return appropriate confirm message when user raises a join request for a company provided cab and he is not part of a cabpool' do
    user = build(:user)
    names = user.name.split(' ')
    cabpool = build(:cabpool)
    cabpool_type = build(:cabpool_type, :company_provided_cab)
    cabpool.cabpool_type = cabpool_type
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by).and_return(user)
    expect(confirm_message_for_the_current_users_join_request cabpool).to eq "Are you sure you want to join this cabpool? This would send a request to the ADMIN."
  end


  it 'should return appropriate confirm message when user raises a join request for a company provided cab and he is not part of a cabpool' do
    user = build(:user)
    names = user.name.split(' ')
    cabpool = build(:cabpool)
    cabpool_type = build(:cabpool_type, :personal_car)
    cabpool.cabpool_type = cabpool_type
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    allow(User).to receive(:find_by).and_return(user)

    expect(confirm_message_for_the_current_users_join_request cabpool).to eq "Are you sure you want to join this cabpool? This would send a request to all members of cabpool"
  end

  it 'should return the cabpool_type id when the params contains cabpool type information' do
    params[:cabpool_type] = {SomeKey: '2'}
    expect(cabpool_type_that_was_retained).to eq '2'
    end

  it 'should return empty hash when params contains no cabpool type information' do
    params[:cabpool_type] = nil
    expect(cabpool_type_that_was_retained).to be nil
  end
end
