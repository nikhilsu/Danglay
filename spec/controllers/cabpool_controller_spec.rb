require 'rails_helper'

RSpec.describe CabpoolController, type: :controller do

  before(:each) do
    session[:userid] = 1
  end

  it 'should render create cabpool page' do
    get :new
    expect(response).to render_template('new')
  end
end
