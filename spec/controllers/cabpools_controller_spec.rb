require 'rails_helper'

RSpec.describe CabpoolsController, type: :controller do

  before(:each) do
     session[:userid] = "thejasb@thoughtworks.com"
     stub_user = User.new(:name => "Thejas", :email => "thejasb@thoughtworks.com", :locality_id => 1)
     allow(User).to receive(:find_by_email).and_return(stub_user)
     allow(stub_user).to receive(:locality_id).and_return(1)
     stub_locality = Locality.new(:name =>"Blah")
     allow(Locality).to receive(:find).and_return(stub_locality)
    allow(stub_locality).to receive(:name).and_return("Blah")
  end

  it 'should render create cabpools page' do
    get :new
    expect(response).to render_template('new')
  end

  it 'should return the locality of user' do
    get :new
    expect(assigns(:locality)).to eq "Blah"
  end

  it 'should render new cabpool page when invalid number of people is entered' do
    post :create, :cabpool => { number_of_people: 0, timein: "9:30", timeout: "2:30", route: 'Nagarbhavi', locality: '7' }
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render show cabpool page when valid details are entered' do
    post :create, :cabpool => { number_of_people: 2, timein: "9:30", timeout: "2:30", route: 'Nagarbhavi', locality: '7' }
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/show'
    expect(cabpool.errors.any?).to be false
  end

  it 'should render new cabpool page with errors when invalid params are passed' do
    post :create, :cabpool => { gibbrish:'hello'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end
end
