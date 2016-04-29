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

  it 'cabpool_type can\'t be empty' do
    cabpool = build(:cabpool, :without_cabpool_type)
    expect(cabpool.valid?).to be false
  end

  it 'Duplicate Localities should be invalid' do
    cabpool = build(:cabpool, :with_duplicate_localities)
    expect(cabpool.valid?).to be false
  end

  it 'More than Five Localities should be invalid' do
    cabpool = build(:cabpool, :more_than_five_localities)
    expect(cabpool.valid?).to be false
  end

  it 'Timein after Timeout should be invalid ' do
    cabpool = build(:cabpool, :timein_after_timeout)
    expect(cabpool.valid?).to be false
  end

  it 'Cabpool is valid if everything is valid' do
      cabpool = build(:cabpool)
      expect(cabpool.valid?).to be true
  end

  it "should show available slots when no users present" do
    cabpool = build(:cabpool, :without_users)
    expect(cabpool.available_slots).to eq 4
  end

  it 'should show available slots when one user is present' do
    cabpool = build(:cabpool, :without_users)
    user = build(:user)
    cabpool.users = [user]
    expect(cabpool.available_slots).to eq 3
  end

  it 'should show available slots when one request made' do
    cabpool = build(:cabpool, :without_users)
    user = build(:user)
    cabpool.requested_users = [user]
    expect(cabpool.available_slots).to eq 4
  end

  it 'users should not be empty' do
    cabpool = build(:cabpool, :without_users)
    expect(cabpool.users.length).to eq 0
    expect(cabpool.valid?).to be false
  end

  it 'should not allow the remarks to have more than 300 characters' do
    cabpool = build(:cabpool, :with_more_than_300_character_remarks)
    expect(cabpool.remarks.length).to be > 300
    expect(cabpool.valid?).to be false
  end

  it 'current value of number of people cannot be less than previous value of a cabpool' do
    cabpool = build(:cabpool)
    cabpool.number_of_people = 3
    cabpool.users = [build(:user)]
    cabpool.localities = [build(:locality)]
    cabpool.save

    cabpool.number_of_people = 2
    expect(cabpool.valid?).to be false
  end

  it 'should add localities in order in which its passed to it' do
    cabpool = build(:cabpool)
    locality1 = create(:locality, name: 'L1')
    locality2 = create(:locality, name: 'L2')
    localities = [locality1, locality2]
    associations_of_the_cabpool = {localities: localities}

    expect(cabpool.localities).to receive(:clear)
    cabpool.add_associations_in_order(associations_of_the_cabpool)

    expect(cabpool.localities).to eq localities
  end

  it 'should add users in order in which its passed to it' do
    cabpool = build(:cabpool)
    user = build(:user)
    another_user = build(:user, :another_user)
    users = [user, another_user]
    associations_of_the_cabpool = {users: users}

    expect(cabpool.users).to receive(:clear)
    cabpool.add_associations_in_order(associations_of_the_cabpool)

    expect(cabpool.users).to eq users
  end

  it 'should add users and localities in order in which its passed to it' do
    cabpool = build(:cabpool)
    locality1 = create(:locality, name: 'L1')
    locality2 = create(:locality, name: 'L2')
    localities = [locality1, locality2]
    user = build(:user)
    another_user = build(:user, :another_user)
    users = [user, another_user]
    associations_of_the_cabpool = {localities: localities, users: users}

    expect(cabpool.users).to receive(:clear)
    cabpool.add_associations_in_order(associations_of_the_cabpool)

    expect(cabpool.users).to eq users
    expect(cabpool.localities).to eq localities
  end

  it 'should have validation errors on attributes and not on associations when attributes are invalid' do
    invalid_cabpool = build(:cabpool, :without_time_in)
    invalid_cabpool.users.clear
    invalid_cabpool.localities.clear
    valid_associations = {localities: [build(:locality)], users: [build(:user)]}

    expect(invalid_cabpool.valid_including_associations? valid_associations).to be false
    expect(invalid_cabpool.errors.messages.empty?).to be false
    expect(invalid_cabpool.errors[:localities].empty?).to be true
    expect(invalid_cabpool.errors[:users].empty?).to be true
  end

  it 'should have validation errors on associations and not on attributes when associations are invalid' do
    invalid_cabpool = build(:cabpool)
    invalid_cabpool.users.clear
    invalid_cabpool.localities.clear
    invalid_associations = {localities: [], users: []}

    expect(invalid_cabpool.valid_including_associations? invalid_associations).to be false
    expect(invalid_cabpool.errors.messages.empty?).to be false
    expect(invalid_cabpool.errors[:timein].empty?).to be true
    expect(invalid_cabpool.errors[:localities].empty?).to be false
    expect(invalid_cabpool.errors[:users].empty?).to be false
  end

  it 'should have validation errors on associations and attributes when attributes and associations are invalid' do
    invalid_cabpool = build(:cabpool, :without_time_in)
    invalid_cabpool.users.clear
    invalid_cabpool.localities.clear
    invalid_associations = {localities: [], users: []}

    expect(invalid_cabpool.valid_including_associations? invalid_associations).to be false
    expect(invalid_cabpool.errors.messages.empty?).to be false
    expect(invalid_cabpool.errors[:timein].empty?).to be false
    expect(invalid_cabpool.errors[:localities].empty?).to be false
    expect(invalid_cabpool.errors[:users].empty?).to be false
  end

  describe 'Order of localities' do
    before(:all) do
      @locality1 = create(:locality, name: 'L1')
      @locality2 = create(:locality, name: 'L2')
      @locality3 = create(:locality, name: 'L3')
    end

    before(:each) do
      @cabpool = build(:cabpool, :without_localities)
    end

    it 'should be L3 L2 L1 when assigned to the cabpool in the same way' do
      @cabpool.localities = [@locality3, @locality2, @locality1]
      @cabpool.save
      expect(@cabpool.ordered_localities).to eq [@locality3, @locality2, @locality1]
    end

    it 'should be L1 L2 L3 when assigned to the cabpool in the same way' do
      @cabpool.localities = [@locality1, @locality2, @locality3]
      @cabpool.save
      expect(@cabpool.ordered_localities).to eq [@locality1, @locality2, @locality3]
    end

    it 'should be L2 L3 L1 when assigned to the cabpool in the same way' do
      @cabpool.localities = [@locality2, @locality3, @locality1]
      @cabpool.save
      expect(@cabpool.ordered_localities).to eq [@locality2, @locality3, @locality1]
    end
  end
end
