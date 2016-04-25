require 'rails_helper'

RSpec.describe Admin::CabpoolsController, type: :controller do

  user = nil

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    ActionMailer::Base.deliveries.clear
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
    all_company_provided_cabpools = [cabpool]
    expect(Cabpool).to receive(:where).and_return(all_company_provided_cabpools)
    expect(all_company_provided_cabpools).to receive(:paginate).and_return(all_company_provided_cabpools)

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

    post :create, :cabpool => {number_of_people: 2, gibbrish: 'hello'}, :passengers => {:user_id => another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:a => '1'}
    cabpool = assigns(:cabpool)

    expect(response).to render_template 'admin/cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new cabpool page with errors when no route is given' do
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

  it 'should render new cabpool page with errors when duplicate routes are given' do
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

  it 'should render new cabpool page with flash message if no passengers are added' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}

    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to eq "Please add some people to the cab"
  end

  it 'should render new cabpool page with flash message when duplicate passengers are added' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)
    allow(another_user).to receive(:save).and_return(true)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :passengers => {user_id1: another_user.id, user_id2: another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}

    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to eq "Same passenger cannot be added multiple times"
  end

  it 'should render new cabpool page with flash message if the add passenger field is left empty' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "2:30"}, :passengers => {:user_id => ''},:cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}
    cabpool = assigns(:cabpool)

    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to be_present
  end

  it 'should render new cabpool page with flash message if the number of  passengers is greater than the capacity' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    first_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(first_user)
    allow(first_user).to receive(:save).and_return(true)
    second_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(second_user)
    allow(second_user).to receive(:save).and_return(true)

    post :create, :cabpool => {number_of_people: 1, timein: "9:30", timeout: "12:30"}, :passengers => {:user_id_one => first_user.id, :user_id_two => second_user.id},:cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}

    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to eq "Number of people are more than the capacity of the cab"
  end

  it 'should render show cabpool page and send mail to all members of cabpool when valid details are entered in create cabpool by admin' do
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

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "12:30", remarks: 'Driver Details'}, :passengers => {:user_id_one => first_user.id, :user_id_two=> second_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)

    expect(response).to redirect_to '/admin'
    expect(cabpool.users.size).to eq ActionMailer::Base.deliveries.size
    expect(cabpool.errors.any?).to be false
  end

  it 'should render Edit' do
    user = build_stubbed(:user)
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build_stubbed(:cabpool)
    expect(Cabpool).to receive(:find_by_id).and_return(cabpool)

    get :edit, :id=> cabpool.id

    expect(response).to render_template "admin/cabpools/edit"
  end

  it 'should render edit cabpool page when invalid number of people is entered during cabpool update' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)
    cabpool = build(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)

    patch :update, :id => cabpool.id, :cabpool => {number_of_people: 0}, :passengers => {:user_id => another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}

    expect(response).to render_template 'admin/cabpools/edit'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render edit cabpool page with flash message if no passengers are added during cabpool update' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)

    patch :update, :id => cabpool.id, :cabpool => {number_of_people: 2}, :cabpool_type => {:cabpool_type_one_id => '1'}

    expect(response).to render_template 'admin/cabpools/edit'
    expect(flash[:danger]).to eq "Please add some people to the cab"
  end

  it 'should render edit cabpool page with flash message when duplicate passengers are added during cabpool update' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(another_user)
    allow(another_user).to receive(:save).and_return(true)
    cabpool = build(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)

    patch :update, :id => cabpool.id, :cabpool => {number_of_people: 2}, :passengers => {user_id1: another_user.id, user_id2: another_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}

    expect(response).to render_template 'admin/cabpools/edit'
    expect(flash[:danger]).to eq "Same passenger cannot be added multiple times"
  end

  it 'should render edit cabpool page with flash message if the add passenger field is left empty during cabpool update' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)

    patch :update, :id => cabpool.id, :cabpool => {number_of_people: 2}, :passengers => {:user_id => ''},:cabpool_type => {:cabpool_type_one_id => '1'}

    expect(response).to render_template 'cabpools/edit'
    expect(flash[:danger]).to be_present
  end

  it 'should render edit cabpool page with flash message if the number of passengers are greater than the capacity during update' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    first_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(first_user)
    allow(first_user).to receive(:save).and_return(true)
    second_user = build_stubbed(:user)
    allow(User).to receive(:find_by_id).and_return(second_user)
    allow(second_user).to receive(:save).and_return(true)
    cabpool = build(:cabpool)
    allow(Cabpool).to receive(:find).and_return(cabpool)

    patch :update, :id => cabpool.id, :cabpool => {number_of_people: 1}, :passengers => {:user_id_one => first_user.id, :user_id_two => second_user.id},:cabpool_type => {:cabpool_type_one_id => '1'}

    expect(response).to render_template 'admin/cabpools/edit'
    expect(flash[:danger]).to eq "Number of people are more than the capacity of the cab"
  end

  it 'should render show cabpool page and send mail to all current and previous members of cabpool when valid details are entered during update' do
    user = build(:user)
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    first_new_user = build(:user, :existing_user)
    first_new_user.id = 1
    allow(first_new_user).to receive(:save).and_return(true)
    second_new_user = build(:user, :another_user)
    second_new_user.id = 2
    allow(second_new_user).to receive(:save).and_return(true)
    allow(User).to receive(:find_by_id).and_return(first_new_user, second_new_user)
    old_user = build(:user, :yet_another_user)
    old_user.id = 3
    cabpool = build(:cabpool)
    cabpool.users = [old_user]
    cabpool.localities = [Locality.find_by_id(1)]
    expect(Cabpool).to receive(:find).and_return(cabpool)
    expect(cabpool).to receive(:save).and_return(true)

    patch :update, :id => cabpool.id, :cabpool => {number_of_people: 2}, :passengers => {:user_id_one => first_new_user.id, :user_id_two=> second_new_user.id}, :cabpool_type => {:cabpool_type_one_id => '1'}

    expect(response).to redirect_to '/admin'
    expect(ActionMailer::Base.deliveries.size).to eq 3
    expect(cabpool.errors.any?).to be false
  end

  it 'should be able to edit the remarks of the cabpool' do
    first_user = build_stubbed(:user)
    admin_role = build_stubbed(:role, :admin_role)
    first_user.role = admin_role
    allow(first_user).to receive(:save).and_return(true)
    cabpool = build(:cabpool, :with_remarks)
    users = []
    users << first_user
    cabpool.users = users
    cabpool.localities = [Locality.find_by_id(1)]
    allow(User).to receive(:find_by_email).and_return(first_user)
    allow(Cabpool).to receive(:find).and_return(cabpool)

    patch :update, :id => cabpool.id, :cabpool => {:remarks => "This is the new remark"}

    expect(cabpool.remarks).to eq "This is the new remark"
  end

  it 'should be able to delete a cabpool' do
    user = build_stubbed(:user)
    admin_role = build_stubbed(:role, :admin_role)
    cabpool = build(:cabpool)
    user.role = admin_role
    user_one = build(:user)
    user_two = build(:user, :yet_another_user)
    cabpool.users = [user_one, user_two]
    request_one = build(:request)
    cabpool.requests = [request_one]
    allow(User).to receive(:find_by_email).and_return(user)
    allow(Cabpool).to receive(:find).and_return(cabpool)
    allow(cabpool).to receive(:destroy).and_return(true)

    expect(Cabpool).to receive(:find).once.and_return(cabpool)
    expect(cabpool).to receive(:destroy!).once
    delete :delete, :id => cabpool.id

    expect(cabpool.users).to be_empty
    expect(cabpool.requests).to be_empty
    expect(flash[:success]).to eq 'Cabpool has been Deleted'
    expect(response).to redirect_to admin_path
  end
end