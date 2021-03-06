# frozen_string_literal: true
# == Schema Information
#
# Table name: cabpools
#
#  id               :integer          not null, primary key
#  number_of_people :integer
#  timein           :time
#  timeout          :time
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  route            :string
#  remarks          :string
#  cabpool_type     :integer
#

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

  it 'gets the show page with a paginated list of all the cabpools' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    another_cabpool = build(:cabpool, :with_remarks)
    all_cabpools = [cabpool, another_cabpool]

    expect(Cabpool).to receive(:all).and_return(all_cabpools)
    expect_any_instance_of(CabpoolsHelper).to receive(:remove_current_users_cabpool).with(array_including(cabpool, another_cabpool)).and_return(all_cabpools)
    expect_any_instance_of(CabpoolsHelper).to receive(:sort_by_available_seats_in_cabpool).and_return(all_cabpools)
    expect(all_cabpools).to receive(:paginate).and_return(all_cabpools)

    get :show

    expect(response).to render_template('show')
    expect(assigns(:cabpools)).to eq all_cabpools
  end

  it 'render home page with filtered list of paginated cabpools when a particular locality is posted to show action' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool, :without_localities)
    locality = build(:locality, name: Faker::Address.street_name)
    cabpools_of_a_particular_locality = [cabpool]
    locality.cabpools = cabpools_of_a_particular_locality
    success_response = Success.new(cabpools_of_a_particular_locality, 'Success message')

    expect(CabpoolService).to receive(:fetch_all_cabpools_of_a_particular_locality).and_return(success_response)
    expect_any_instance_of(CabpoolsHelper).to receive(:remove_current_users_cabpool).with(array_including(cabpool)).and_return(cabpools_of_a_particular_locality)
    expect_any_instance_of(CabpoolsHelper).to receive(:sort_by_available_seats_in_cabpool).and_return(cabpools_of_a_particular_locality)
    expect(cabpools_of_a_particular_locality).to receive(:paginate).and_return(cabpools_of_a_particular_locality)

    post :show, localities: { locality_id: locality.id }

    expect(response).to render_template('show')
    expect(assigns(:cabpools)).to eq cabpools_of_a_particular_locality
  end

  it 'render home page with all cabpools and flash if no locality selected' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    another_cabpool = build(:cabpool, :with_remarks)
    all_cabpools = [cabpool, another_cabpool]
    failure_response = Failure.new(all_cabpools, 'Select a locality')

    expect(CabpoolService).to receive(:fetch_all_cabpools_of_a_particular_locality).and_return(failure_response)
    expect_any_instance_of(CabpoolsHelper).to receive(:remove_current_users_cabpool).with(array_including(cabpool, another_cabpool)).and_return(all_cabpools)
    expect_any_instance_of(CabpoolsHelper).to receive(:sort_by_available_seats_in_cabpool).and_return(all_cabpools)
    expect(all_cabpools).to receive(:paginate).and_return(all_cabpools)

    post :show, localities: { locality_id: '' }

    expect(response).to render_template('show')
    expect(assigns(:cabpools)).to eq all_cabpools
    expect(flash[:danger]).to eq 'Select a locality'
  end

  it 'renders create cabpools page' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    get :new
    expect(response).to render_template('new')
  end

  it 'renders new cabpool page with errors when invalid params are passed' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :create, cabpool: { gibbrish: 'hello' }, cabpool_type: { cabpool_type_two_id: '2' }, localities: { a: '1' }
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'renders new cabpool page with errors when no cabpool_type is given' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :create, cabpool: { number_of_people: 2, timein: '9:30', timeout: '12:30' }, cabpool_type: { cabpool_type_one_id: '' }, localities: { locality_one_id: '' }
    cabpool = assigns(:cabpool)
    expect(response).to render_template 'cabpools/new'

    expect(cabpool.errors.any?).to be true
  end

  it 'renders new carpool page with errors cabpool type is not company provided persistence fails' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    duplicate_locality = build(:locality)
    duplicate_locality.id = 1
    failure = Failure.new(nil, 'Failure Message')
    expect(LocalityService).to receive(:fetch_all_localities).with([duplicate_locality.id.to_s, duplicate_locality.id.to_s]).and_return([duplicate_locality, duplicate_locality])

    expect(CabpoolService).to receive(:persist).and_return(failure)
    post :create, cabpool: { number_of_people: 2, timein: '9:30', timeout: '12:30' }, cabpool_type: { cabpool_type_two_id: '2' }, localities: { locality_one_id: '1', locality_two_id: '1' }

    expect(response).to render_template 'cabpools/new'
    expect(flash[:danger]).to eq 'Cannot create because of the following errors'
  end

  it 'renders show cabpool page when valid details are entered and cabpool type is not company provided' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    first_updated_locality = build(:locality)
    first_updated_locality.id = 1
    success = Success.new(nil, 'Success message')
    expect(LocalityService).to receive(:fetch_all_localities).with([first_updated_locality.id.to_s]).and_return([first_updated_locality])

    expect(CabpoolService).to receive(:persist).and_return(success)
    post :create, cabpool: { number_of_people: 2, timein: '9:30', timeout: '12:30', remarks: 'Driver Details.' }, cabpool_type: { cabpool_type_two_id: '2' }, localities: { locality_one_id: '1' }

    expect(response).to redirect_to your_cabpools_path
    expect(flash[:success]).to eq 'You have successfully created your cab pool.'
  end

  it 'renders show cabpool page when valid details are entered and cabpool type is company provided' do
    user = build(:user, :existing_user)
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, cabpool: { number_of_people: 2, timein: '9:30', timeout: '12:30', remarks: 'Driver Details.' }, cabpool_type: { cabpool_type_two_id: '1' }, localities: { locality_one_id: '1' }

    cabpool = assigns(:cabpool)

    expect(flash[:success]).to eq 'You have successfully requested the admins for a cab pool.'
    expect(response).to redirect_to root_url
    expect(cabpool.errors.any?).to be false
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  it 'redirects to new user path when unregistered user tries to create a pool' do
    @current_user = nil
    session[:Email] = 'newUser@mail.com'
    get :new
    expect(response).to redirect_to new_user_path
  end

  it 'shows respective success message when join is successful when cabpool type is not company provided' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    post :create, cabpool: { number_of_people: 2, timein: '9:30', timeout: '12:30' }, cabpool_type: { cabpool_type_two_id: '2' }, localities: { locality_one_id: '1' }
    cabpool = assigns(:cabpool)
    post :join, cabpool: { id: cabpool.id }
    expect(response).to redirect_to root_path

    expect(flash[:success]).to eq 'Join Request Sent!'
    expect(user.requests.count).to eq 1
  end

  it 'shows respective error message when join is unsuccessful' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    post :create, cabpool: { number_of_people: 1, timein: '9:30', timeout: '12:30' }, cabpool_type: { cabpool_type_two_id: '2' }, localities: { locality_one_id: '1' }
    cabpool = assigns(:cabpool)
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :join, cabpool: { id: cabpool.id }
    user = build(:user, :another_user)
    allow(User).to receive(:find_by_email).and_return(user)
    post :join, cabpool: { id: cabpool.id }
    expect(response).to redirect_to root_path
    expect(flash[:danger]).to eq 'Cab capacity exceeded!'
  end

  it 'sends emails to cabpool users when a user joins that cabpool' do
    user = build(:user, :existing_user)
    allow(User).to receive(:find_by_email).and_return(user)

    post :create, cabpool: { number_of_people: 4, timein: '9:30', timeout: '12:30' }, cabpool_type: { cabpool_type_two_id: '2' }, localities: { locality_one_id: '1' }

    cabpool = assigns(:cabpool)
    allow(Cabpool).to receive(:find_by_id).and_return(cabpool)
    requesting_user = build(:user)
    allow(User).to receive(:find_by_email).and_return(requesting_user)

    post :join, cabpool: { id: cabpool.id }

    expect(cabpool.users.count).to eq ActionMailer::Base.deliveries.size
    expect(response).to redirect_to root_path
  end

  it 'sends email admins when a user joins the campany provided cabpool' do
    cabpool = Cabpool.new(number_of_people: 3, timein: '9:30', timeout: '12:30')
    cabpool.cabpool_type = :company_provided_cab
    user = build(:user, :existing_user)
    allow(Cabpool).to receive(:find_by_id).and_return(cabpool)
    allow(User).to receive(:find_by_email).and_return(user)
    allow(User).to receive(:find_by).and_return(user)
    allow(cabpool).to receive(:cabpool_type).and_return(:company_provided_cab)
    post :join, cabpool: { id: cabpool.id }
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(response).to redirect_to root_path
  end

  it 'redirects to home page if current user does not have a cab pool' do
    user = build(:user)
    allow(User).to receive(:find_by).and_return(user)
    post :leave

    expect(response).to redirect_to root_path
  end

  it 'sends inactive email to admin when cabpool has only 1 memeber in it' do
    cabpool = Cabpool.new(number_of_people: 3, timein: '9:30', timeout: '12:30')
    cabpool.cabpool_type = :company_provided_cab
    user = build(:user)
    user.cabpool = cabpool
    another_user = build(:user, :another_user)
    cabpool.users << another_user
    allow(User).to receive(:find_by).and_return(user)
    allow(cabpool.users).to receive(:size).and_return(1)

    post :leave
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  it 'sets the current user\'s cabpool to nil if the user leaves the cab pool and send email to existing members' do
    cabpool = Cabpool.new(number_of_people: 3, timein: '9:30', timeout: '12:30')
    cabpool.cabpool_type = :company_provided_cab
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

  it 'sets the current user\'s cabppol to nil if the user leaves the cab pool with no existing members in the cabpool' do
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

  it 'renders error message when request is deleted from the request table' do
    user = build(:user)
    allow(User).to receive(:find).and_return(user)
    allow(Request).to receive(:find_by_user_id).and_return(nil)
    get :approve_reject_handler, approve: 'true', token: 'ABCD', user: '1', approver: '2'
    expect(response).to render_template 'request_duplicate'
  end

  it 'renders error message when token is not the same' do
    user = build(:user)
    allow(User).to receive(:find).and_return(user)
    request = build_stubbed(:request)
    allow(Request).to receive(:find_by).and_return(request)
    get :approve_reject_handler, approve: 'true', token: 'ABCD', user: '1', cabpool: '2', approver: '2'
    expect(response).to render_template 'request_invalid'
  end

  it 'renders Accept message and send email to approved user and other cabpool members when token is same and approve is true' do
    approving_user = build(:user)
    cabpool = build(:cabpool)
    request = build(:request)
    user = request.user
    user.requests = [request]
    allow(user).to receive(:save).and_return(true)
    allow(request).to receive(:destroy!).and_return(true)
    allow(User).to receive(:find).and_return(user)
    allow(Request).to receive(:find_by).and_return(request)
    allow(request).to receive(:approve_digest).and_return('ABCD')
    allow(User).to receive(:find_by).and_return(approving_user)
    allow(approving_user).to receive(:cabpool).and_return(cabpool)

    get :approve_reject_handler, approve: 'true', token: 'ABCD', user: '1', cabpool: '2', approver: approving_user.id
    expect(ActionMailer::Base.deliveries.size).to eq 2
    expect(response).to render_template 'request_accept'
  end

  it 'renders Accept message and send email to approved user and other cabpool members and send email to previous cabpoolers when token is same and approve is true' do
    request = build_stubbed(:request)
    requesting_user = request.user
    another_user = build(:user, :another_user)
    existing_cabpool_member = build(:user, :yet_another_user)
    approving_user = build(:user)
    old_cabpool = build(:cabpool, :without_users)
    old_cabpool.users << [requesting_user, another_user]
    requesting_cabpool = build(:cabpool, :without_users)
    requesting_cabpool.users << [approving_user, existing_cabpool_member]
    request.cabpool = requesting_cabpool

    allow(requesting_user).to receive(:save).and_return(true)
    allow(request).to receive(:destroy!).and_return(true)
    allow(User).to receive(:find).and_return(requesting_user)
    allow(Request).to receive(:find_by).and_return(request)
    allow(request).to receive(:approve_digest).and_return('ABCD')
    allow(User).to receive(:find_by).and_return(approving_user)
    allow(approving_user).to receive(:cabpool).and_return(old_cabpool)

    get :approve_reject_handler, approve: 'true', token: 'ABCD', user: '1', cabpool: '2', approver: approving_user.id
    expect(ActionMailer::Base.deliveries.size).to eq 3
    expect(response).to render_template 'request_accept'
  end

  it 'renders reject message when token is same and approve is false' do
    request = build_stubbed(:request)
    user = request.user
    allow(user).to receive(:save).and_return(true)
    allow(request).to receive(:destroy!).and_return(true)
    allow(User).to receive(:find).and_return(user)
    allow(Request).to receive(:find_by).and_return(request)
    allow(request).to receive(:approve_digest).and_return('ABCD')
    get :approve_reject_handler, approve: 'false', token: 'ABCD', user: '1', cabpool: '2', approver: '2'
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(response).to render_template 'request_reject'
  end

  it 'renders your_cabpools view for a user having a cabpool' do
    user = build(:user)
    user.cabpool = build(:cabpool)
    allow(User).to receive(:find_by).and_return(user)
    get :your_cabpools
    expect(response).to render_template 'your_cabpools'
  end

  it 'renders accept message if request is accept via notification and user has requested for this cabpool' do
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

  it 'renders accept message if request is accept via notification and user has requested for this cabpool and delete him from previous cabpool if he was only person in previous cabpool' do
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

  it 'renders invalid message if request is accept via notification and user has not requested for this cabpool' do
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

  it 'renders rejected message if request is reject via notification and user has requested for this cabpool' do
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

  it 'renders rejected message if request is reject via notification and user has not requested for this cabpool' do
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

  it 'updates user status on notification view for approved user' do
    user = build_stubbed(:user)
    user.status = 'approved'
    allow(User).to receive(:find_by).and_return(user)

    post :view_notification

    expect(user.status).to eq nil
    expect(response).to redirect_to your_cabpools_path
  end

  it 'updates user status on notification view for rejected user' do
    user = build_stubbed(:user)
    user.status = 'rejected'
    allow(User).to receive(:find_by).and_return(user)

    post :view_notification

    expect(user.status).to eq nil
    expect(response).to redirect_to root_path
  end

  it 'redirects to root path if user status is not approved nor rejected' do
    user = build_stubbed(:user)
    user.status = 'not'
    allow(User).to receive(:find_by).and_return(user)

    post :view_notification

    expect(response).to redirect_to root_path
  end

  it 'does not route to new if user has already a part of cabpool' do
    user = build_stubbed(:user)
    cabpool = build_stubbed(:cabpool)
    user.cabpool = cabpool
    allow(User).to receive(:find_by).and_return(user)

    get :new

    expect(flash[:danger]).to eq 'You are already part of a Cab pool. Please leave the cabpool to create a new cab pool.'
    expect(response).to redirect_to your_cabpools_path
  end

  it 'renders Edit when the current user has a cabpool' do
    user = build(:user)
    another_user = build(:user, :another_user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool_to_update = build(:cabpool, :personal_car)
    cabpool_to_update.users = [user, another_user]

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_update)
    get :edit, id: 1

    expect(response).to render_template 'cabpools/edit'
  end

  it 'redirects to home page when a user tries to Edit a company provided cabpool' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    cabpool.users = [user]
    cabpool.id = 1
    cabpool.cabpool_type = :company_provided_cab
    expect(Cabpool).to receive(:find_by_id).and_return(cabpool)

    get :edit, id: cabpool.id

    expect(response).to redirect_to '/'
    expect(flash[:danger]).to eq 'Cannot Edit a Company Provided Cabpool'
  end

  it 'renders home page when the user tries to edit a cabpool that he/she is not part of' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    cabpool_to_edit_that_does_not_include_user = build(:cabpool)
    user.cabpool = cabpool

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_edit_that_does_not_include_user)
    get :edit, id: 1

    expect(response).to redirect_to root_url
    expect(flash[:danger]).to eq 'Cannot Edit a cabpool that you are not part of'
  end

  it 'renders home page when the user tries to edit a cabpool that does not exist' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    user.cabpool = cabpool

    expect(Cabpool).to receive(:find_by_id).and_return(nil)
    get :edit, id: 1234

    expect(response).to redirect_to root_url
    expect(flash[:danger]).to eq 'Cannot Edit a cabpool that you are not part of'
  end

  it 'renders home page when the current user does not have a cabpool' do
    user = build(:user)
    allow(User).to receive(:find_by_email).and_return(user)
    user.cabpool = nil

    get :edit, id: 1

    expect(response).to redirect_to root_url
  end

  it 'successfullies update a cabpool and send out emails to concerned members when all valid details and localities are entered by user' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    cabpool_to_update = build(:cabpool, :personal_car)
    another_user_part_of_cabpool = build(:user, :another_user)
    cabpool_to_update.users = [user, another_user_part_of_cabpool]
    first_updated_locality = build(:locality)
    first_updated_locality.id = 10
    success = Success.new(cabpool_to_update, 'Success message')
    allow(cabpool_to_update).to receive(:ordered_localities).and_return([first_updated_locality])
    expect(LocalityService).to receive(:fetch_all_localities).with([first_updated_locality.id.to_s]).and_return([first_updated_locality])

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_update)
    expect(CabpoolService).to receive(:persist).and_return(success)
    patch :update, id: cabpool_to_update.id, cabpool: { number_of_people: 4, timein: '9:30', timeout: '12:30', remarks: 'Edited Remark', route: '{source: New Locality, destination: ThoughtWorks}' }, localities: { key1: first_updated_locality.id }

    expect(response).to redirect_to your_cabpools_path
    expect(cabpool_to_update.errors.any?).to be false
    expect(flash[:success]).to eq 'Your Cabpool has been Updated'
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  it 'redirects to home page when a user tries to update a Company provided cabpool' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    cabpool_to_update = build(:cabpool)
    cabpool_to_update.cabpool_type = :company_provided_cab
    cabpool_to_update.users = [user]

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_update)
    patch :update, id: cabpool_to_update.id, cabpool: { number_of_people: 4, timein: '19:30', timeout: '12:30', remarks: 'Edited Remark', route: '{source: New Locality, destination: Thoughtworks}' }, localities: { key1: 1, key2: 2 }

    expect(response).to redirect_to root_url
    expect(flash[:danger]).to eq 'Cannot Edit a Company Provided Cabpool'
  end

  it 'does not update a cabpool when persistence of the cabpool fails' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    cabpool_to_update = build(:cabpool, :external_cab)
    duplicate_locality = build(:locality)
    duplicate_locality.id = 10
    cabpool_to_update.users = [user]
    failure = Failure.new(cabpool_to_update, 'Failure Message')
    expect(LocalityService).to receive(:fetch_all_localities).with([duplicate_locality.id.to_s, duplicate_locality.id.to_s]).and_return([duplicate_locality, duplicate_locality])

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_update)
    expect(CabpoolService).to receive(:persist).and_return(failure)
    patch :update, id: cabpool_to_update.id, cabpool: { number_of_people: 4, timein: '19:30', timeout: '12:30', remarks: 'Edited Remark', route: '{source: New Locality, destination: Thoughtworks}' }, localities: { key1: duplicate_locality.id, key2: duplicate_locality.id }

    expect(response).to render_template 'edit'
    expect(flash[:danger]).to eq 'Cannot update because of the following errors'
    expect(cabpool_to_update.valid?).to be false
  end

  it 'does not allow a user to update a cabpool that he/she is not part of' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    first_updated_locality = build(:locality)
    cabpool_that_user_part_of = build(:cabpool)
    user.cabpool = cabpool_that_user_part_of
    cabpool_to_update_that_does_not_include_user = build(:cabpool)

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_update_that_does_not_include_user)
    patch :update, id: '', cabpool: { number_of_people: 4, timein: '9:30', timeout: '12:30', remarks: 'Edited Remark', route: '' }, localities: { key1: first_updated_locality.id }

    expect(response).to redirect_to root_url
    expect(flash[:danger]).to eq 'Cannot Edit a cabpool that you are not part of'
  end

  it 'does not allow a user to update a cabpool that does not exist' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    first_updated_locality = build(:locality)
    cabpool_that_user_part_of = build(:cabpool)
    user.cabpool = cabpool_that_user_part_of

    expect(Cabpool).to receive(:find_by_id).and_return(nil)
    patch :update, id: '', cabpool: { number_of_people: 4, timein: '9:30', timeout: '12:30', remarks: 'Edited Remark', route: '' }, localities: { key1: first_updated_locality.id }

    expect(response).to redirect_to root_url
    expect(flash[:danger]).to eq 'Cannot Edit a cabpool that you are not part of'
  end

  it 'does not allow a user to update if he/she is not part of a cabpool' do
    user = build(:user)
    expect(User).to receive(:find_by_email).and_return(user)
    first_updated_locality = build(:locality)
    user.cabpool = nil

    patch :update, id: '', cabpool: { number_of_people: 4, timein: '9:30', timeout: '12:30', remarks: 'Edited Remark', route: '' }, localities: { key1: first_updated_locality.id }

    expect(response).to redirect_to root_url
    expect(flash[:danger]).to eq 'You are not part of a cabpool.'
  end
end
