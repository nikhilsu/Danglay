# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'CustomErrorPages', type: :feature do
  before(:each) do
    page.set_rack_session(FirstName: 'Deepika')
    page.set_rack_session(LastName: 'Vasudevan')
    page.set_rack_session(Email: 'vdeepika@thoughtworks.com')
  end

  scenario 'should render custom 404 page when 404 error occurs' do
    visit '/nonExistentPage'
    expect(page.body).to have_content '404 Page not found!'
    expect(page.status_code).to eq 404
  end
  scenario 'should render custom 500 page when 500 error occurs' do
    page.driver.post '/saml/consume' # raise 500 error
    expect(page.body).to have_content 'Oops! something went wrong'
    expect(page.status_code).to eq 500
  end
end
