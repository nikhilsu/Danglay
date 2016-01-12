require 'rails_helper'

RSpec.describe Admin::CabpoolsController, type: :controller do

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

  it 'should show error page if user is not an admin' do
    role = build_stubbed(:role)
    user.role = role
    allow(User).to receive(:find_by_email).and_return(user)

    get :show

    expect(response).to render_template 'custom_errors/not_found_error'
  end

  it 'should display list of company provided cabpools if user is admin' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build_stubbed(:cabpool)
    cabpool_type = build_stubbed(:cabpool_type)
    cabpool.cabpool_type = cabpool_type
    allow(Cabpool).to receive(:where).and_return([cabpool])



    get :show

    expect(assigns(:cabpools)).to eq [cabpool]
    expect(response).to render_template 'admin/cabpools/show'
  end

  it 'should render create pool page' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    get :new

    expect(response). to render_template 'admin/cabpools/new'
  end

  it 'should render new cabpool page when invalid number of people is entered' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)
    post :create, :cabpool => {number_of_people: 0, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id => another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'admin/cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new cabpool page with errors when invalid params are passed' do
    admin_role = build(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)

    post :create, :cabpool => {number_of_people: 0, gibbrish: 'hello'}, :passengers => {:user_id => another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:a => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'admin/cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when no route is given' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)
    allow(another_user).to receive(:save).and_return(true)

    post :create, :cabpool => {number_of_people: 1, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id => another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => ''}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when no cabpool_type is given' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)
    allow(another_user).to receive(:save).and_return(true)

    post :create, :cabpool => {number_of_people: 1, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id => another_user.id}, :cabpool_type => {:cabpool_type_one_id => ''}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when duplicate routes are given' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id => another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new capool page with flash message if no passengers are added' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to be_present
  end

  it 'should render new capool page with flash message if the add passenger field is left empty' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id => ''},:cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to be_present
  end

  it 'should render new capool page with flash message if the number of  passengers is greater than the capacity' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    first_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(first_user)
    allow(first_user).to receive(:save).and_return(true)
    second_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(second_user)
    allow(second_user).to receive(:save).and_return(true)

    post :create, :cabpool => {number_of_people: 1, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id_one => first_user.id, :user_id_two => second_user.id},:cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to be_present
  end

  it 'should render show cabpool page when valid details are entered' do
    user = build(:user)
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool_type = create(:cabpool_type).id
    first_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(first_user)
    allow(first_user).to receive(:save).and_return(true)
    second_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(second_user)
    allow(second_user).to receive(:save).and_return(true)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id_one => first_user.id, :user_id_two=> second_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1'}

    cabpool = assigns(:cabpool)

    expect(response).to redirect_to '/admin'
    expect(cabpool.errors.any?).to be false
  end

  it 'should render Edit' do
    user = build_stubbed(:user)
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build_stubbed(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)

    get :edit, :id=> cabpool.id

    expect(response).to render_template "admin/cabpools/edit"
  end

  it 'should update cabpool users' do
    user = build_stubbed(:user)
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build_stubbed(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)
    allow(cabpool).to receive(:save).and_return(true)

    patch :update, :id => cabpool.id , :users => {:user_id => user.id}

    expect(response).to redirect_to admin_path
  end

  it 'should not update cabpool users if form is not valid' do
    user = build_stubbed(:user)
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build_stubbed(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)
    allow(cabpool).to receive(:save).and_return(false)

    patch :update, :id => cabpool.id , :users => {:user_id => user.id}

    expect(response).to redirect_to "/admin_cabpool/#{cabpool.id}/edit"

  end
end
