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
    page.assert_selector('div.glyphicon-bell', :count => 0)
    visit new_cabpool_path
    fill_in 'Capacity of Cab', with: ''
    fill_in 'Arrival time to office', with: ''
    fill_in 'Departure time from office', with: ''
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Create a pool'

    expect(page.current_path).to eq '/cabpools'
    expect(page.body).to have_content("This is not a number.")
    expect(page.body).to have_content("is not a valid time")
    expect(page.body).to have_content("should not be empty")
    visit new_cabpool_path
    fill_in 'Capacity of Cab', with: '3'
    fill_in 'Arrival time to office', with: '12:23 PM'
    fill_in 'Departure time from office', with: '9:00 PM'
    find(:xpath, '//*[@id="cabpool_type"]/div[1]/select/option[2]').select_option
    page.execute_script "window.scrollBy(0,10000)"

    find('#addLocality').trigger('click')
    find(:xpath, '//*[@id="localitySelections"]/div[1]/div/div/div[1]/input').set("HAL")
    find(:xpath, '//*[@id="localitySelections"]/div[1]/div/div/div[1]/input').native.send_keys(:return)
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Create a pool'
    expect(page.current_path).to eq '/'
    page.assert_selector('div.glyphicon-bell', :count => 1)

    page.set_rack_session(userid: 101)
    page.set_rack_session(registered_uid: 101)
    page.set_rack_session(FirstName: 'Sandeep')
    page.set_rack_session(LastName: 'Hegde')
    page.set_rack_session(Email: 'sandeeph@thoughtworks.com')

    visit root_path
    all("input[value='Join']")[-1].click

    page.set_rack_session(userid: 100)
    page.set_rack_session(registered_uid: 100)
    page.set_rack_session(FirstName: 'Deepika')
    page.set_rack_session(LastName: 'Vasudevan')
    page.set_rack_session(Email: 'vdeepika@thoughtworks.com')

    visit root_path
    expect(page.body).to have_content("Sandeep Hegde from AF Station Yelahanka has requested for a cabpool")
  end
end
