require 'rails_helper'

RSpec.describe CabpoolsController, type: :controller do

  include SessionsHelper

  before(:each) do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    ActionMailer::Base.deliveries.clear
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
  end

  it 'render home page with all cabpools and flash if no locality selected' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :show, localities: { locality_id: '' }
    expect(response).to render_template('show')
    expect(flash[:danger]).to eq "Select a locality"
  end

  it 'should render create cabpools page' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    get :new
    expect(response).to render_template('new')
  end

  it 'should render new cabpool page when invalid number of people is entered' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :create, :cabpool => {number_of_people: 0, timein: "9:30", timeout: "12:30"}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new cabpool page with errors when invalid params are passed' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :create, :cabpool => {gibbrish: 'hello'}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:a => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when no route is given' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "12:30"}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:locality_one_id => ''}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when no cabpool_type is given' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "12:30"}, :cabpool_type => {:cabpool_type_one_id => ''}, :localities => {:locality_one_id => ''}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'

    expect(cabpool.errors.any?).to be true
  end

  it 'should render new carpool page with errors when duplicate routes are given' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "12:30"}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:locality_one_id => '1', :locality_two_id => '1'}
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'should render show cabpool page when valid details are entered and cabpool type is not company provided' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "12:30", remarks: 'Driver Details.'}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:locality_one_id => '1'}

    cabpool = assigns(:cabpool)
    expect(response).to redirect_to root_url
    expect(cabpool.errors.any?).to be false
  end

    it 'should render show cabpool page when valid details are entered and cabpool type is company provided' do
    user = build(:user, :existing_user)
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "12:30", remarks: 'Driver Details.'}, :cabpool_type => {:cabpool_type_two_id => '1'}, :localities => {:locality_one_id => '1'}

    cabpool = assigns(:cabpool)

    expect(flash[:success]).to eq flash[:success] = "You have successfully requested the admins for a cab pool."
    expect(response).to redirect_to root_url
    expect(cabpool.errors.any?).to be false
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  it "should redirect to new user path when unregistered user tries to create a pool" do
    @current_user = nil
    session[:Email] = 'newUser@mail.com'
    get :new
    expect(response).to redirect_to new_user_path
  end

  it 'should show respective success message when join is successful when cabpool type is not company provided' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    post :create, :cabpool => {number_of_people: 2, timein: "9:30", timeout: "12:30"}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:locality_one_id => '1'}
    cabpool = assigns(:cabpool)
    post :join, cabpool: {id: cabpool.id}
    expect(response).to redirect_to root_path

    expect(flash[:success]).to eq "Join Request Sent! Please check the 'MyRide' tab for details"
    expect(user.requests.count).to eq 1
  end

  it 'should show respective error message when join is unsuccessful' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    post :create, :cabpool => {number_of_people: 1, timein: "9:30", timeout: "12:30"}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:locality_one_id => '1'}
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

  it 'should send emails to cabpool users when a user joins that cabpool' do
    user = build(:user, :existing_user)
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, :cabpool => {number_of_people: 4, timein: "9:30", timeout: "12:30"}, :cabpool_type => {:cabpool_type_two_id => '2'}, :localities => {:locality_one_id => '1'}

    cabpool = assigns(:cabpool)
    cabpool.users = [build(:user)]
    allow(Cabpool).to receive(:find_by_id).and_return(cabpool)
    post :join, cabpool: {id: cabpool.id}
    expect(cabpool.users.count).to eq ActionMailer::Base.deliveries.size
    expect(response).to redirect_to root_path
  end

  it 'should send email admins when a user joins the campany provided cabpool' do
    cabpool = Cabpool.new({number_of_people: 3, timein: "9:30", timeout: "12:30"})
    cabpool_type = CabpoolType.new({:id => '1'})
    cabpool.cabpool_type = cabpool_type
    user = build(:user, :existing_user)
    allow(Cabpool).to receive(:find_by_id).and_return(cabpool)
    allow(User).to receive(:find_by_email).and_return(user)
    allow(User).to receive(:find_by).and_return(user)
    allow(cabpool).to receive(:cabpool_type).and_return(cabpool_type)
    allow(cabpool_type).to receive(:name).and_return('Company provided Cab')
    post :join, cabpool: {id: cabpool.id}
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(response).to redirect_to root_path
  end

  it 'should redirect to home page if current user does not have a cab pool' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    post :leave

    expect(response).to redirect_to root_path
  end

  it "should send inactive email to admin when cabpool has only 1 memeber in it" do
    cabpool = Cabpool.new({number_of_people: 3, timein: "9:30", timeout: "12:30"})
    cabpool_type = CabpoolType.new({:id => '1'})
    cabpool.cabpool_type = cabpool_type
    user = build(:user)
    user.cabpool = cabpool
    another_user = build(:user, :another_user)
    cabpool.users << another_user
    allow(User).to receive(:find_by).and_return(user)
    allow(cabpool.users).to receive(:size).and_return(1)

    post :leave
    expect(ActionMailer::Base.deliveries.size).to eq 2
  end

  it 'should set the current user\'s cabpool to nil if the user leaves the cab pool and send email to existing members' do
    cabpool = Cabpool.new({number_of_people: 3, timein: "9:30", timeout: "12:30"})
    cabpool_type = CabpoolType.new({:id => '1'})
    cabpool.cabpool_type = cabpool_type
    user = build(:user)
    user.cabpool = cabpool
    another_user = build(:user, :another_user)
    yet_another_user = build(:user, :yet_another_user)
    cabpool.users << another_user
    cabpool.users << yet_another_user
    allow(User).to receive(:find_by).and_return(user)

    post :leave
    expect(current_user.cabpool).to eq nil
    expect(ActionMailer::Base.deliveries.size).to eq 3
    expect(flash[:success]).to eq 'You have left your cab pool.'
  end


  it 'should set the current user\'s cabppol to nil if the user leaves the cab pool with no existing members in the cabpool' do

    user = build_stubbed(:user)
    cabpool = build_stubbed(:cabpool)
    user.cabpool = cabpool

    allow(User).to receive(:find_by).and_return(user)
    allow(user).to receive(:save).and_return(true)
    allow(cabpool).to receive(:destroy).and_return(true)
    cabpool = assigns(:cabpool)

    post :leave

    expect(cabpool).to eq nil
    expect(flash[:success]).to eq 'You have left your cab pool.'
  end

  it 'should render error message when request is deleted from the request table' do
    user = build(:user)
    allow(User).to receive(:find).and_return(user)
    allow(Request).to receive(:find_by_user_id).and_return(nil)
    get :approve_reject_handler, approve: "true", token: "ABCD", user: '1'
    expect(response).to render_template 'request_duplicate'
  end

  it 'should render error message when token is not the same' do
    user = build(:user)
    allow(User).to receive(:find).and_return(user)
    request = build_stubbed(:request)
    allow(Request).to receive(:find_by).and_return(request)
    get :approve_reject_handler, approve: "true", token: "ABCD", user: '1', cabpool: '2'
    expect(response).to render_template 'request_invalid'
  end

  it 'should render Accept message and send email to approved user and other cabpool members when token is same and approve is true' do
    approving_user = build(:user)
    cabpool = build(:cabpool)
    request = build(:request)
    user = request.user
    user.requests = [request]
    allow(user).to receive(:save).and_return(true)
    allow(request).to receive(:destroy!).and_return(true)
    allow(User).to receive(:find).and_return(user)
    allow(Request).to receive(:find_by).and_return(request)
    allow(request).to receive(:approve_digest).and_return("ABCD")
    allow(User).to receive(:find_by).and_return(approving_user)
    allow(approving_user).to receive(:cabpool).and_return(cabpool)
    get :approve_reject_handler, approve: "true", token: "ABCD", user: '1', cabpool: '2'
    expect(ActionMailer::Base.deliveries.size).to eq 2
    expect(response).to render_template 'request_accept'
  end

  it 'should render Accept message and send email to approved user and other cabpool members and send email to previous cabpoolers when token is same and approve is true' do
    request = build_stubbed(:request)
    user = request.user
    approving_user = build(:user)
    cabpool = build(:cabpool, :without_users)
    cabpool.users << [user ,approving_user]

    allow(user).to receive(:save).and_return(true)
    allow(request).to receive(:destroy!).and_return(true)
    allow(User).to receive(:find).and_return(user)
    allow(Request).to receive(:find_by).and_return(request)
    allow(request).to receive(:approve_digest).and_return("ABCD")
    allow(User).to receive(:find_by).and_return(approving_user)
    allow(approving_user).to receive(:cabpool).and_return(cabpool)

    get :approve_reject_handler, approve: "true", token: "ABCD", user: '1', cabpool: '2'
    expect(ActionMailer::Base.deliveries.size).to eq 3
    expect(response).to render_template 'request_accept'
  end

  it 'should render reject message when token is same and approve is false' do
    request = build_stubbed(:request)
    user = request.user
    allow(user).to receive(:save).and_return(true)
    allow(request).to receive(:destroy!).and_return(true)
    allow(User).to receive(:find).and_return(user)
    allow(Request).to receive(:find_by).and_return(request)
    allow(request).to receive(:approve_digest).and_return("ABCD")
    get :approve_reject_handler, approve: "false", token: "ABCD", user: '1', cabpool: '2'
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(response).to render_template 'request_reject'
  end

  it 'should redirect your_cabpools if user has no cabpools and requests' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    get :your_cabpools
    expect(response).to redirect_to root_path
  end

  it 'should render accept message if request is accept via notification and user has requested for this cabpool' do
    request = build(:request)
    requested_user = request.user
    cabpool = request.cabpool
    user = build_stubbed(:user)
    cabpool.users << [user]
    cabpool.localities << [build_stubbed(:locality)]
    approving_user = build(:user)

    allow(User).to receive(:find_by_email).and_return(user)
    allow(User).to receive(:find_by_cabpool_id).and_return(cabpool)
    allow(Request).to receive(:find_by).and_return(request)
    allow(User).to receive(:find).and_return(requested_user)
    allow(user.cabpool.requested_users).to receive(:exists?).and_return(true)
    allow(User).to receive(:find_by).and_return(approving_user)
    allow(approving_user).to receive(:cabpool).and_return(cabpool)
    post :approve_via_notification, user_id: '3'
    expect(response).to render_template 'cabpools/request_accept'
  end

  it 'should render accept message if request is accept via notification and user has requested for this cabpool and delete him from previous cabpool if he was only person in previous cabpool' do
    request = build(:request)
    requested_user = request.user
    requested_user_cabpool = build(:cabpool, :without_users)
    requested_user.cabpool = requested_user_cabpool
    requested_user_cabpool.users = [requested_user]
    cabpool = request.cabpool
    user = build_stubbed(:user)
    cabpool.users << [user]
    cabpool.localities << [build_stubbed(:locality)]
    approving_user = build(:user)

    allow(User).to receive(:find_by_email).and_return(user)
    allow(User).to receive(:find_by_cabpool_id).and_return(cabpool)
    allow(Request).to receive(:find_by).and_return(request)
    allow(User).to receive(:find).and_return(requested_user)
    allow(requested_user_cabpool).to receive(:destroy).and_return true
    allow(user.cabpool.requested_users).to receive(:exists?).and_return(true)
    allow(User).to receive(:find_by).and_return(approving_user)
    allow(approving_user).to receive(:cabpool).and_return(cabpool)
    post :approve_via_notification, user_id: '2'
    expect(response).to render_template 'cabpools/request_accept'
  end

  it 'should render invalid message if request is accept via notification and user has not requested for this cabpool' do
    request = build(:request)
    requested_user = request.user
    cabpool = request.cabpool
    user = build_stubbed(:user)
    cabpool.users << [user]
    cabpool.localities << [build_stubbed(:locality)]

    allow(User).to receive(:find_by_email).and_return(user)
    allow(User).to receive(:find_by_cabpool_id).and_return(cabpool)
    allow(Request).to receive(:find_by_user_id).and_return(request)
    allow(User).to receive(:find).and_return(requested_user)
    allow(user.cabpool.requested_users).to receive(:exists?).and_return(false)
    post :approve_via_notification, user: '2'
    expect(response).to render_template 'cabpools/request_invalid'
  end

  it 'should render rejected message if request is reject via notification and user has requested for this cabpool' do
    request = build(:request)
    requested_user = request.user
    cabpool = request.cabpool
    user = build_stubbed(:user)
    cabpool.users << [user]
    cabpool.localities << [build_stubbed(:locality)]

    allow(User).to receive(:find_by_email).and_return(user)
    allow(User).to receive(:find_by_cabpool_id).and_return(cabpool)
    allow(Request).to receive(:find_by).and_return(request)
    allow(User).to receive(:find).and_return(requested_user)
    allow(user.cabpool.requested_users).to receive(:exists?).and_return(true)

    post :reject_via_notification, user_id: '2'
    expect(response).to render_template 'cabpools/request_reject'
  end

  it 'should render rejected message if request is reject via notification and user has not requested for this cabpool' do
    request = build(:request)
    requested_user = request.user
    cabpool = request.cabpool
    user = build_stubbed(:user)
    cabpool.users << [user]
    cabpool.localities << [build_stubbed(:locality)]

    allow(User).to receive(:find_by_email).and_return(user)
    allow(User).to receive(:find_by_cabpool_id).and_return(cabpool)
    allow(Request).to receive(:find_by_user_id).and_return(request)
    allow(User).to receive(:find).and_return(requested_user)
    allow(user.cabpool.requested_users).to receive(:exists?).and_return(false)

    post :reject_via_notification, user: '2'
    expect(response).to render_template 'cabpools/request_invalid'

  end

  it 'should update user status on notification view for approved user' do
    user = build_stubbed(:user)
    user.status = 'approved'
    allow(User).to receive(:find_by).and_return(user)

    post :view_notification

    expect(user.status).to eq nil
    expect(response).to redirect_to your_cabpools_path
  end

  it 'should update user status on notification view for rejected user' do
    user = build_stubbed(:user)
    user.status = 'rejected'
    allow(User).to receive(:find_by).and_return(user)

    post :view_notification

    expect(user.status).to eq nil
    expect(response).to redirect_to root_path
  end

  it 'should redirect to root path if user status is not approved nor rejected' do
    user = build_stubbed(:user)
    user.status = 'not'
    allow(User).to receive(:find_by).and_return(user)

    post :view_notification

    expect(response).to redirect_to root_path
  end

  it 'should not route to new if user has already a part of cabpool' do
    user = build_stubbed(:user)
    cabpool = build_stubbed(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by).and_return(user)

    get :new

    expect(flash[:danger]).to eq "You are already part of a Cab pool. Please leave the cabpool to create a new cab pool."
    expect(response).to redirect_to your_cabpools_path
  end

end