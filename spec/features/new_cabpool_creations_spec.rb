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
    fill_in 'Capacity of Cab', with: ''
    fill_in 'Arrival time to office', with: ''
    fill_in 'Departure time from office', with: ''
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Create a pool'
    expect(page.current_path).to eq '/cabpools'
    expect(page.body).to have_content("This is not a number.")
    expect(page.body).to have_content("is not a valid time")
    visit new_cabpool_path
    fill_in 'Capacity of Cab', with: '3'
    fill_in 'Arrival time to office', with: '12:23 PM'
    fill_in 'Departure time from office', with: '9:00 PM'
    find('#addLocality').trigger('click')
    find(:xpath, '//*[@id="localitySelections"]/div[1]/div/div/div[1]/input').set("HAL")
    find(:xpath, '//*[@id="localitySelections"]/div[1]/div/div/div[1]/input').native.send_keys(:return)
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Create a pool'
    expect(page.current_path).to eq '/'
  end
end
