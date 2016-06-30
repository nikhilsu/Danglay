# frozen_string_literal: true
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

  it 'shows error page if user is not an admin' do
    role = build_stubbed(:role)
    user.role = role
    allow(User).to receive(:find_by_email).and_return(user)

    get :show

    expect(response).to render_template 'custom_errors/not_found_error'
  end

  it 'shows error page if user is unregistered and not an admin' do
    allow(User).to receive(:find_by_email).and_return(nil)

    get :show

    expect(response).to render_template 'custom_errors/not_found_error'
  end

  it 'displays list of company provided cabpools if user is admin' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build_stubbed(:cabpool)
    cabpool.cabpool_type = :company_provided_cab
    all_company_provided_cabpools = [cabpool]
    expect(Cabpool).to receive(:where).and_return(all_company_provided_cabpools)
    expect(all_company_provided_cabpools).to receive(:paginate).and_return(all_company_provided_cabpools)

    get :show

    expect(assigns(:cabpools)).to eq [cabpool]
    expect(response).to render_template 'admin/cabpools/show'
  end

  it 'renders create pool page' do
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    get :new

    expect(response). to render_template 'admin/cabpools/new'
  end

  it 'renders new cabpool page when persistence of cabpool fails' do
    admin = build(:user)
    admin_role = build(:role, :admin_role)
    admin.role = admin_role
    expect(User).to receive(:find_by_email).and_return(admin)
    another_user = build(:user)
    expect(UserService).to receive(:fetch_all_users).with([another_user.id]).and_return([another_user])

    expect(CabpoolService).to receive(:persist).and_return(Failure.new(nil, 'Failure Message'))
    post :create, cabpool: { number_of_people: 0, timein: '9:30', timeout: '2:30' }, passengers: { user_id: another_user.id }, cabpool_type: { cabpool_type_one_id: '1' }

    expect(response).to render_template 'admin/cabpools/new'
    expect(flash[:danger]).to eq 'Failure Message'
  end

  it 'renders new cabpool page with errors when invalid params are passed' do
    admin_role = build(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    expect(UserService).to receive(:fetch_all_users).with([another_user.id.to_s]).and_return([another_user])

    post :create, cabpool: { number_of_people: 2, gibbrish: 'hello' }, passengers: { user_id: another_user.id }, cabpool_type: { cabpool_type_one_id: '1' }, localities: { a: '1' }
    cabpool = assigns(:cabpool)

    expect(response).to render_template 'admin/cabpools/new'
    expect(cabpool.errors.any?).to be true
  end

  it 'renders show cabpool page and send mail to all members of cabpool when valid details are entered and cabpool is persisted successfully' do
    admin = build(:user)
    admin_role = build_stubbed(:role, :admin_role)
    admin.role = admin_role
    allow(User).to receive(:find_by_email).and_return(admin)
    first_user = build_stubbed(:user)
    allow(first_user).to receive(:save).and_return(true)
    second_user = build_stubbed(:user)
    allow(second_user).to receive(:save).and_return(true)
    first_locality = build(:locality)
    first_locality.id = 1
    expect(LocalityService).to receive(:fetch_all_localities).with([first_locality.id.to_s]).and_return([first_locality])
    expect(UserService).to receive(:fetch_all_users).with([first_user.id.to_s, second_user.id.to_s]).and_return([first_user, first_user])

    expect(CabpoolService).to receive(:persist) do
      assigns(:cabpool).users = [first_user, second_user]
      assigns(:cabpool).localities = [first_locality]
      Success.new(nil, 'Success Message')
    end
    post :create, cabpool: { number_of_people: 2, timein: '9:30', timeout: '12:30', remarks: 'Driver Details' }, passengers: { user_id_one: first_user.id, user_id_two: second_user.id }, cabpool_type: { cabpool_type_one_id: '1' }, localities: { locality_one_id: first_locality.id }

    cabpool = assigns(:cabpool)
    expect(response).to redirect_to '/admin'
    expect(cabpool.users.size).to eq ActionMailer::Base.deliveries.size
    expect(cabpool.timein).to eq Time.new(2000, 0o1, 0o1, 9, 30, 0, '+00:00')
    expect(cabpool.timeout).to eq Time.new(2000, 0o1, 0o1, 12, 30, 0, '+00:00')
    expect(cabpool.remarks).to eq 'Driver Details'
    expect(cabpool.errors.any?).to be false
    expect(ActionMailer::Base.deliveries.size).to eq 2
  end

  it 'renders Edit' do
    user = build(:user)
    admin_role = build(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    cabpool.id = 1
    cabpool.cabpool_type = :company_provided_cab
    expect(Cabpool).to receive(:find_by_id).and_return(cabpool)

    get :edit, id: cabpool.id

    expect(response).to render_template 'admin/cabpools/edit'
  end

  it 'redirects to admin page when admin tries to Edit a non company provided cabpool' do
    user = build(:user)
    admin_role = build(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build(:cabpool)
    cabpool.id = 1
    cabpool.cabpool_type = :personal_car
    expect(Cabpool).to receive(:find_by_id).and_return(cabpool)

    get :edit, id: cabpool.id

    expect(response).to redirect_to '/admin'
    expect(flash[:danger]).to eq 'Cannot Edit a Non-Company Provided Cabpool'
  end

  it 'redirects to admin home when admin tries to update a non company provided cabpool' do
    user = build(:user)
    user.role = build_stubbed(:role, :admin_role)
    expect(User).to receive(:find_by_email).and_return(user)
    cabpool_to_update = build(:cabpool)
    cabpool_to_update.cabpool_type = :personal_car

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_update)
    patch :update, id: cabpool_to_update.id, cabpool: { number_of_people: 1, remarks: 'Edited Remark' }, cabpool_type: { cabpool_type_one_id: '1' }

    expect(response).to redirect_to '/admin'
    expect(flash[:danger]).to eq 'Cannot Edit a Non-Company Provided Cabpool'
  end

  it 'renders edit cabpool page when persistence of the cabpool fails' do
    user = build(:user)
    user.role = build_stubbed(:role, :admin_role)
    expect(User).to receive(:find_by_email).and_return(user)
    another_user = build_stubbed(:user)
    cabpool_to_update = build(:cabpool)
    cabpool_to_update.users = [another_user]
    cabpool_to_update.cabpool_type = :company_provided_cab
    failure = Failure.new(cabpool_to_update, 'Failure Message')

    expect(Cabpool).to receive(:find_by_id).and_return(cabpool_to_update)
    expect(CabpoolService).to receive(:persist).and_return(failure)
    patch :update, id: cabpool_to_update.id, cabpool: { number_of_people: 1, remarks: 'Edited Remark' }, cabpool_type: { cabpool_type_one_id: '1' }

    expect(response).to render_template 'admin/cabpools/edit'
    expect(flash[:danger]).to eq 'Failure Message'
  end

  it 'renders show cabpool page and send mail to all current and previous members of cabpool and update localities when valid details are entered during update' do
    user = build(:user)
    admin_role = build_stubbed(:role, :admin_role)
    user.role = admin_role
    allow(User).to receive(:find_by_email).and_return(user)
    first_new_user = build(:user, :existing_user)
    first_new_user.id = 1
    second_new_user = build(:user, :another_user)
    second_new_user.id = 2
    old_user = build(:user, :yet_another_user)
    old_user.id = 3
    first_locality = build(:locality)
    second_locality = build(:locality, :another_locality)
    cabpool = build(:cabpool)
    cabpool.users = [old_user]
    cabpool.cabpool_type = :company_provided_cab
    cabpool.localities = [Locality.find_by_id(1)]
    success = Success.new(cabpool, 'Success Message')
    allow(cabpool).to receive(:ordered_localities).and_return(cabpool.localities)
    expect(Cabpool).to receive(:find_by_id).and_return(cabpool)
    expect(UserService).to receive(:fetch_all_users).with(%w(1 2)).and_return([first_new_user, second_new_user])
    expect(LocalityService).to receive(:fetch_all_localities).with(%w(1 2)).and_return([first_locality, second_locality])

    expect(CabpoolService).to receive(:persist) do
      cabpool.users = [first_new_user, second_new_user]
      cabpool.localities.clear
      cabpool.localities = [first_locality, second_locality]
      success
    end
    patch :update, id: cabpool.id, cabpool: { number_of_people: 2, remarks: 'This is the new remark', route: 'Ola new route' }, passengers: { user_id_one: first_new_user.id, user_id_two: second_new_user.id }, localities: { key1: 1, key2: 2 }, cabpool_type: { cabpool_type_one_id: '1' }

    expect(cabpool.errors.any?).to be false
    expect(cabpool.number_of_people).to eq 2
    expect(cabpool.remarks).to eq 'This is the new remark'
    expect(cabpool.users).to eq [first_new_user, second_new_user]
    expect(cabpool.route).to eq 'Ola new route'
    expect(cabpool.localities).to eq [first_locality, second_locality]
    expect(response).to redirect_to '/admin'
    expect(ActionMailer::Base.deliveries.size).to eq 3
  end

  it 'is able to delete a cabpool' do
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
    allow(Cabpool).to receive(:destroy).with(cabpool.id).and_return(true)

    delete :delete, id: cabpool.id

    expect(flash[:success]).to eq 'Cabpool has been deleted'
    expect(response).to redirect_to admin_path
  end
end
