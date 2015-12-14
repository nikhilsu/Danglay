require 'rails_helper'

RSpec.describe CabpoolsController, type: :controller do

  include SessionsHelper

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:registered_uid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
  end

  it 'should get the show page' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    get :show
    expect(response).to render_template('show')
  end

  it 'render home page with filtered results post to show' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool, :without_localities)
    locality = create(:locality, name: Faker::Address.street_name)
    cabpool.localities << locality
    locality.cabpools << cabpool
    post :show, localities: {locality_id: locality.id}
    expect(response).to render_template('show')
    expect(flash.empty?).to be true
  end

  it 'render home page with all cabpools and flash if no cabs for searched locality' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool, :without_localities)
    locality = Locality.create(name: Faker::Address.street_address)
    cabpool.localities << locality
    post :show, localities: { locality_id: locality.id }
    expect(response).to render_template('show')
    expect(flash[:danger]).to eq "Locality has no cabpools"
  end

  it 'render home page with all cabpools and flash if no locality selected' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :show, localities: { locality_id: '' }
    expect(response).to render_template('show')
    expect(flash[:danger]).to eq "Select a locality"
  end


  it 'should render create cabpools page' do
    get :new
    expect(response).to render_template('new')
  end

  it 'should render new cabpool page when invalid number of people is entered' do
    post :create, :cabpool => {number_of_people: 0, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new cabpool page with errors when invalid params are passed' do
    post :create, :cabpool => {gibbrish: 'hello'}, :localities => {:a => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when no route is given' do
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => ''}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when duplicate routes are given' do
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render show cabpool page when valid details are entered' do
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to redirect_to root_url
    expect(cabpool.errors.any?).to be false
  end

  it "should redirect to new user path when unregistered user tries to create a pool" do
    session[:registered_uid] = nil
    get :new
    expect(response).to redirect_to new_user_path
  end

  it 'should show respective success message when join is successful' do
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :join, cabpool: {id: cabpool.id}
    expect(response).to redirect_to root_path
    expect(flash[:success]).to eq 'Request Sent!'
    expect(user.requests.count).to eq 1
  end

  it 'should show respective error message when join is unsuccessful' do
    post :create, :cabpool => {number_of_people: 1, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :join, cabpool: {id: cabpool.id}
    user = build(:user, :another_user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :join, cabpool: {id: cabpool.id}
    expect(response).to redirect_to root_path
    expect(flash[:danger]).to eq 'Cab capacity exceeded!'
  end

  it 'should show already requested for user who is already requested' do
    post :create, :cabpool => {number_of_people: 1, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    user = build(:user)
    request = build(:request)
    user.requests = [request]
    allow(User).to receive(:find_by_email).and_return(user)
    post :join, cabpool: {id: cabpool.id}
    expect(response).to redirect_to root_path
    expect(flash[:danger]).to eq 'You have already requested to a cab. Please wait for the request to be processed'
  end

  it 'should send emails to cabpool users when a user joins that cabpool' do
    post :create, :cabpool => {number_of_people: 4, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    user = build(:user, :existing_user)
    cabpool.users = [build(:user)]
    allow(Cabpool).to receive(:find_by_id).and_return(cabpool)
    allow(User).to receive(:find_by_email).and_return(user)
    post :join, cabpool: {id: cabpool.id}
    expect(cabpool.users.count).to eq ActionMailer::Base.deliveries.size
    expect(response).to redirect_to root_path
  end

  it 'should redirect to home page if current user does not have a cab pool' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    post :leave
    expect(response).to redirect_to root_path
  end

  it 'should set the current user\'s cabppol to nil if the user leaves the cab pool' do
    post :create, :cabpool => {number_of_people: 3, timein: "9:30", timeout: "2:30"}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    before_count = Cabpool.all.count;
    user = build(:user)
    user.cabpool = cabpool
    allow(User).to receive(:find_by).and_return(user)
    post :leave
    after_count = Cabpool.all.count;
    expect(current_user.cabpool).to eq nil
    expect(before_count - after_count).to eq 1
    expect(flash[:success]).to eq 'You have left your cab pool.'
  end
end
