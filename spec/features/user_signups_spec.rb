require 'rails_helper'

RSpec.describe "UserSignups", type: :feature do
  before(:each) do
    page.set_rack_session(userid: 'SirThinksALot@blah.com')
    page.set_rack_session(FirstName: 'Sir Thinks ')
    page.set_rack_session(LastName: ' A Lot')
    page.set_rack_session(Email: 'SirThinksALot@blah.com')
  end

  scenario 'valid user signup with existing location' do
    visit new_user_path
    fill_in 'user_emp_id', with: '12345'
    fill_in 'user_address', with: 'No.322, Mars'
    fill_in 'user_phone_no', with: '+91 9080706055'
    select('Banaswadi', from: 'user_locality')
    click_button 'Update Profile'
    expect(page.current_path).to eq root_path
  end

  scenario 'valid user signup with a new location', js: true do
    visit new_user_path
    fill_in 'user_emp_id', with: '12345'
    fill_in 'user_address', with: 'No.322, Mars'
    fill_in 'user_phone_no', with: '+91 9080706055'
    page.execute_script "window.scrollBy(0, 10000)"
    find(:xpath, '//*[@id="new_user"]/div/div/div/input').set('Other')
    find(:xpath, '//*[@id="new_user"]/div/div/div/input').native.send_keys(:return)
    fill_in 'otherBox', with: 'AF Station Yelahanka'
    page.execute_script "window.scrollBy(0, 10000)"
    click_button 'Update Profile'
    expect(page.current_path).to eq '/users'
    page.document.has_content? 'locality already exists'
    page.execute_script "window.scrollBy(0, 10000)"
    find(:xpath, '//*[@id="new_user"]/div/div/div/div/input').set('Other')
    find(:xpath, '//*[@id="new_user"]/div/div/div/div/input').native.send_keys(:return)
    fill_in 'otherBox', with: 'Jupiter'
    page.execute_script "window.scrollBy(0, 10000)"
    click_button 'Update Profile'
    expect(page.current_path).to eq root_path
  end
end
