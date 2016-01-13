require 'rails_helper'

RSpec.feature "NewCabpoolCreations", type: :feature do
  before(:each) do
    page.set_rack_session(userid: 100)
    page.set_rack_session(registered_uid: 100)
    page.set_rack_session(FirstName: 'Deepika')
    page.set_rack_session(LastName: 'Vasudevan')
    page.set_rack_session(Email: 'vdeepika@thoughtworks.com')
  end

  scenario 'valid creation of cabpool', js: true do
    visit root_path
    page.assert_selector('div.notification', :count => 0)
    visit new_cabpool_path
    fill_in 'cabpool_number_of_people', with: ''
    fill_in 'cabpool_timein', with: ''
    fill_in 'cabpool_timeout', with: ''
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Create a pool'

    expect(page.current_path).to eq '/cabpools'
    expect(page.body).to have_content("This is not a number.")
    expect(page.body).to have_content("is not a valid time")
    expect(page.body).to have_content("should not be empty")
    visit new_cabpool_path
    fill_in 'cabpool_number_of_people', with: '3'
    fill_in 'cabpool_timein', with: '12:23 PM'
    fill_in 'cabpool_timeout', with: '9:00 PM'
    find(:xpath, '//*[@id="cabpool_type"]/div[1]/select/option[2]').select_option
    page.execute_script "window.scrollBy(0,10000)"

    find('#addLocality').trigger('click')
    find(:xpath, '//*[@id="localitySelections"]/div[1]/div/div/div[1]/input').set("HAL")
    find(:xpath, '//*[@id="localitySelections"]/div[1]/div/div/div[1]/input').native.send_keys(:return)
    click_button 'Create a pool'
    expect(page.current_path).to eq '/'
    page.assert_selector('div.notification', :count => 1)

    page.set_rack_session(userid: 101)
    page.set_rack_session(registered_uid: 101)
    page.set_rack_session(FirstName: 'Sandeep')
    page.set_rack_session(LastName: 'Hegde')
    page.set_rack_session(Email: 'sandeeph@thoughtworks.com')

    visit root_path
    all("button[name='Join Ride']")[-1].click

    page.set_rack_session(userid: 100)
    page.set_rack_session(registered_uid: 100)
    page.set_rack_session(FirstName: 'Deepika')
    page.set_rack_session(LastName: 'Vasudevan')
    page.set_rack_session(Email: 'vdeepika@thoughtworks.com')

    visit root_path
    expect(page.body).to have_content("Sandeep Hegde from AF Station Yelahanka has requested for a cabpool")
  end
end
