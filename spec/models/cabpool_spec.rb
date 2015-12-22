require 'rails_helper'

RSpec.describe Cabpool, type: :model do

  it 'Number of people should not be empty' do
    cabpool = build(:cabpool, :without_number_of_people)
    expect(cabpool.valid?).to be false
  end

  it 'Time in of the cabpool should not be empty' do
    cabpool = build(:cabpool, :without_time_in)
    expect(cabpool.valid?).to be false
  end

  it 'Time out of the cabpool should not be empty' do
    cabpool = build(:cabpool, :without_time_out)
    expect(cabpool.valid?).to be false
  end

  it 'Number of people should be less than or equal to 4' do
      cabpool = build(:cabpool, :without_less_than_four_people)
      expect(cabpool.valid?).to be false
  end

  it 'Number of people should be greater than or equal to 1' do
      cabpool = build(:cabpool, :without_greater_than_one_person)
      expect(cabpool.valid?).to be false
  end

  it 'Timein should be a in a HH:MM format' do
      cabpool = build(:cabpool, :timein_in_invalid_format)
      expect(cabpool.valid?).to be false
  end

  it 'Timein can have seconds and milliseconds in its HH:MM format' do
      cabpool = build(:cabpool, :timein_with_milliseconds)
      expect(cabpool.valid?).to be true
  end

  it 'Timeout should be a in a HH:MM format' do
      cabpool = build(:cabpool, :timeout_in_invalid_format)
      expect(cabpool.valid?).to be false
  end

  it 'Timeout can have seconds and milliseconds in its HH:MM format' do
      cabpool = build(:cabpool, :timeout_with_milliseconds)
      expect(cabpool.valid?).to be true
  end

  it 'Localities can\'t be empty' do
    cabpool = build(:cabpool, :without_localities)
    expect(cabpool.valid?).to be false
  end

  it 'cabpool_type should be there' do
    cabpool = build(:cabpool, :without_cabpool_type)
    cabpool_type = build(:cabpool_type)
    cabpool.cabpool_type = cabpool_type
    expect(cabpool.cabpool_type.name).to eq(cabpool_type.name)
  end

  it 'Duplicate Localities should be invalid' do
    cabpool = build(:cabpool, :with_duplicate_localities)
    expect(cabpool.valid?).to be false
  end

  it 'More than Five Localities should be invalid' do
    cabpool = build(:cabpool, :more_than_five_localities)
    expect(cabpool.valid?).to be false
  end

  it 'Cabpool is valid if everything is valid' do
      cabpool = build(:cabpool)
      expect(cabpool.valid?).to be true
  end

  it "should show available slots when no users present" do
    cabpool = build(:cabpool)
    expect(cabpool.available_slots).to eq 4
  end

  it "should show available slots when one user is present" do
    cabpool = build(:cabpool)
    user = build(:user)
    cabpool.users = [user]
    expect(cabpool.available_slots).to eq 3
  end

  it "should show available slots when one request made" do
    cabpool = build(:cabpool)
    user = build(:user)
    cabpool.requested_users = [user]
    expect(cabpool.available_slots).to eq 3
  end

  it 'should show localities in order' do
    cabpool = build(:cabpool, :without_localities)
    locality1 = create(:locality, name: "L1")
    locality2 = create(:locality, name: "L2")
    locality3 = create(:locality, name: "L3")
    cabpool.localities = [locality3, locality2, locality1]
    cabpool.save
    expect(cabpool.ordered_localities).to eq [locality3, locality2, locality1]
  end
end
