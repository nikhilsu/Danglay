require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET new' do
    it 'should render new page' do
      get :new
      expect(response).to render_template('new')
    end
  end
end
