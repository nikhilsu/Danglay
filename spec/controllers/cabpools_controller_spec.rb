require 'rails_helper'

RSpec.describe CabpoolsController, type: :controller do

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:userid] = user.id
    session[:registered_uid] = user.id
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    end

  it 'should render create cabpools page' do
    get :new
    expect(response).to render_template('new')
  end

  it 'should render new cabpool page when invalid number of people is entered' do
    post :create, :cabpool => { number_of_people: 0, timein: "9:30", timeout: "2:30"}, :localities => { :locality_one_id => '1' }
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new cabpool page with errors when invalid params are passed' do
    post :create, :cabpool => { gibbrish:'hello'}, :localities => { :a => '1' }
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when no route is given' do
    post :create, :cabpool => { number_of_people: 2, timein: "9:30", timeout: "2:30"}, :localities => { :locality_one_id => '' }
    cabpool = assigns(:cabpool)
    count = cabpool.localities.count
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
    expect(count).to eq 0
  end

  it 'should render new carpool page with errors when duplicate routes are given' do
    post :create, :cabpool => { number_of_people: 2, timein: "9:30", timeout: "2:30"}, :localities => { :locality_one_id => '1', :locality_two_id => '1' }
    cabpool = assigns(:cabpool)
    count = cabpool.localities.count
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
    expect(count).to eq 0
  end

  it 'should render show cabpool page when valid details are entered' do
    post :create, :cabpool => { number_of_people: 2, timein: "9:30", timeout: "2:30"}, :localities => { :locality_one_id => '1' }
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/show'
    expect(cabpool.errors.any?).to be false
  end

  it "should redirect to new user path when unregistered user tries to create a pool" do
    session[:registered_uid] = nil
    get :new
    expect(response).to redirect_to new_user_path
  end
end
