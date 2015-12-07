require 'rails_helper'

RSpec.feature "NewCabpoolCreations", type: :feature do

  before(:each) do
    page.set_rack_session(userid: 22)
    page.set_rack_session(registered_uid: 22)
    page.set_rack_session(FirstName: 'Deepika')
    page.set_rack_session(LastName: 'Vasudevan')
    page.set_rack_session(Email: 'vdeepika@thoughtworks.com')
  end

  scenario 'valid creation of cabpool', js: true do
    visit new_cabpool_path
    fill_in 'Number of people to travel with', with: ''
    fill_in 'Pick-up time to office', with: ''
    fill_in 'Pick-up time from office', with: ''
    find(:css, '.localityForm > select').find(:xpath, 'option[1]').select_option
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Create a pool'
    expect(page.current_path).to eq '/cabpools'
    expect(page.body).to have_content("This is not a number.")
    expect(page.body).to have_content("is not a valid time")
    expect(page.body).to have_content("Empty")
    visit new_cabpool_path
    fill_in 'Number of people to travel with', with: '3'
    fill_in 'Pick-up time to office', with: '12:23 PM'
    fill_in 'Pick-up time from office', with: '9:00 PM'
    find(:css, '.localityForm > select').find(:xpath, 'option[2]').select_option
    find('#addLocality').trigger('click')
    find(:css, '#localitySelections > div > div > select').find(:xpath, 'option[3]').select_option
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Create a pool'
    expect(page.current_path).to eq '/'
  end
end
