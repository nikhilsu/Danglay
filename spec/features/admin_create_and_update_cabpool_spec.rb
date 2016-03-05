require 'rails_helper'

RSpec.feature "CompanyProviderCabpool", type: :feature do
  before(:each) do
    page.set_rack_session(userid: 101)
    page.set_rack_session(FirstName: 'Sandeep')
    page.set_rack_session(LastName: 'Hegde')
    page.set_rack_session(Email: 'sandeeph@thoughtworks.com')
  end

  scenario 'should be deleted when all users are removed from the cabpool by admin', js: true do
    visit admin_path
    find(:xpath, '//*[@id="edit_cabpool_1"]/button').click
    expect(page).to have_selector('#removePassenger')
    page.all('#removePassenger').each do |minus_sign|
      minus_sign.click
    end
    page.execute_script "window.scrollBy(0,10000)"
    click_button 'Update pool'
    expect(page).to have_css('.popup.is-visible')
    expect(page.body).to have_content("This Cabpool will be Deleted as it has no Passengers. Do you wish to proceed?")
    page.find('#yes').click
    expect(page).to_not have_css('.popup.is-visible')
    end
end
