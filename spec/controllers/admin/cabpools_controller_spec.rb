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
    role = build_stubbed(:role, :admin_role)
    user.role = role
    allow(User).to receive(:find_by_email).and_return(user)
    cabpool = build_stubbed(:cabpool)
    cabpool_type = build_stubbed(:cabpool_type)
    cabpool.cabpool_type = cabpool_type
    allow(Cabpool).to receive(:find_by_cabpool_type_id).and_return([cabpool])

    get :show

    expect(assigns(:cabpools)).to eq [cabpool]
    expect(response).to render_template 'admin/cabpools/show'
  end
end
