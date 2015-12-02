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

  it 'Timeout should be a in a HH:MM format' do
      cabpool = build(:cabpool, :timeout_in_invalid_format)
      expect(cabpool.valid?).to be false
  end

  it 'Cabpool is valid if everything is valid' do
      cabpool = build(:cabpool)
      expect(cabpool.valid?).to be true
  end
end
