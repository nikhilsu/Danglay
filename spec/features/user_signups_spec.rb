require 'rails_helper'

RSpec.describe "UserSignups", type: :feature do
  before(:each) do
    page.set_rack_session(userid: 'SirThinksALot@blah.com')
    page.set_rack_session(FirstName: 'Sir Thinks ')
    page.set_rack_session(LastName: ' A Lot')
    page.set_rack_session(Email: 'SirThinksALot@blah.com')
  end

  scenario 'valid user signup with exisiting location' do
    visit new_user_path
    fill_in 'Employee ID', with: '12345'
    fill_in 'Address', with: 'No.322, Mars'
    select('Mars', from: 'Locality')
    click_button 'Update Profile'
    expect(page.current_path).to eq root_path
  end

  scenario 'valid user signup with a new location', js: true do
    visit new_user_path
    fill_in 'Employee ID', with: '12345'
    fill_in 'Address', with: 'No.322, Mars'
    select('Other', from: 'Locality')
    fill_in 'otherBox', with: 'Mars'
    click_button 'Update Profile'
    expect(page.current_path).to eq '/users'
    page.document.has_content? 'locality already exists'
    select('Other', from: 'Locality')
    fill_in 'otherBox', with: 'Jupiter'
    click_button 'Update Profile'
    expect(page.current_path).to eq root_path
  end
end