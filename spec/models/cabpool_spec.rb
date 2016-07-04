# frozen_string_literal: true
# == Schema Information
#
# Table name: cabpools
#
#  id               :integer          not null, primary key
#  number_of_people :integer
#  timein           :time
#  timeout          :time
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  route            :string
#  remarks          :string
#  cabpool_type     :integer
#

require 'rails_helper'

RSpec.describe Cabpool, type: :model do
  describe 'validations' do
    describe 'number_of_people' do
      # TODO: Rewrite with shoulda-matchers gem so that these become one-liners
      it 'Number of people should not be empty' do
        cabpool = build(:cabpool, :without_number_of_people)
        expect(cabpool.valid?).to be false
      end

      it 'Number of people should be less than or equal to 6' do
        cabpool = build(:cabpool, :more_than_six_people)
        expect(cabpool.valid?).to be false
      end

      it 'Number of people should be greater than or equal to 1' do
        cabpool = build(:cabpool, :lesser_than_one_person)
        expect(cabpool.valid?).to be false
      end
    end

    describe 'timein' do
      it 'of the cabpool should not be empty' do
        cabpool = build(:cabpool, :without_time_in)
        expect(cabpool.valid?).to be false
      end

      it 'is a in a HH:MM format' do
        cabpool = build(:cabpool, :timein_in_invalid_format)
        expect(cabpool.valid?).to be false
      end

      it 'can have seconds and milliseconds in its HH:MM format' do
        cabpool = build(:cabpool, :timein_with_milliseconds)
        expect(cabpool.valid?).to be true
      end

      it 'is before timeout' do
        cabpool = build(:cabpool, :timein_after_timeout)
        expect(cabpool.valid?).to be false
      end
    end

    describe 'timeout' do
      it 'of the cabpool should not be empty' do
        cabpool = build(:cabpool, :without_time_out)
        expect(cabpool.valid?).to be false
      end

      it 'is a in a HH:MM format' do
        cabpool = build(:cabpool, :timeout_in_invalid_format)
        expect(cabpool.valid?).to be false
      end

      it 'can have seconds and milliseconds in its HH:MM format' do
        cabpool = build(:cabpool, :timeout_with_milliseconds)

        expect(cabpool.valid?).to be true
      end
    end

    describe 'localities' do
      it 'Localities can\'t be empty' do
        cabpool = build(:cabpool, :without_localities)
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
    end

    describe 'cabpool_type' do
      it 'can\'t be empty' do
        cabpool = build(:cabpool, :without_cabpool_type)
        expect(cabpool.valid?).to be false
      end
    end

    describe 'users' do
      it 'users should not be empty' do
        cabpool = build(:cabpool, :without_users)
        expect(cabpool.users.length).to eq 0
        expect(cabpool.valid?).to be false
      end

      it 'does not allow duplicate users to be part of the cabpool' do
        cabpool = build(:cabpool, :without_users)
        duplicate_user = build(:user)
        cabpool.users = [duplicate_user, duplicate_user]
        expect(cabpool.valid?).to be false
        expect(cabpool.errors[:users]).to eq ['Duplicate User entered']
      end
    end

    describe 'remarks' do
      it 'length cannot be more than 300 characters' do
        cabpool = build(:cabpool, :with_more_than_300_character_remarks)
        expect(cabpool.remarks.length).to be > 300
        expect(cabpool.valid?).to be false
      end
    end
  end

  describe 'relationships' do
    xit { has_and_belongs_to_many(:localities) }
    xit { has_many(:users).dependent(:nullify) }
    xit { has_many(:requests).dependent(:nullify) }
    xit { has_many(:requested_users).through(:requests) }

    describe 'destroy' do
      it 'should nullify users when a cabpool is destroyed'
      it 'should nullify requests when a cabpool is destroyed'
    end
  end

  describe 'available_slots' do
    it 'shows available slots when no users present' do
      cabpool = build(:cabpool, :without_users)
      expect(cabpool.available_slots).to eq 4
    end

    it 'shows available slots when one user is present' do
      cabpool = build(:cabpool, :without_users)
      user = build(:user)
      cabpool.users = [user]
      expect(cabpool.available_slots).to eq 3
    end

    it 'shows available slots when one request made' do
      cabpool = build(:cabpool, :without_users)
      user = build(:user)
      cabpool.requested_users = [user]
      expect(cabpool.available_slots).to eq 4
    end
  end

  describe 'add_associations_in_order' do
    it 'adds localities in order in which its passed to it' do
      cabpool = build(:cabpool)
      locality1 = create(:locality, name: 'L1')
      locality2 = create(:locality, name: 'L2')
      localities = [locality1, locality2]
      associations_of_the_cabpool = { localities: localities }

      expect(cabpool.localities).to receive(:clear)
      cabpool.add_associations_in_order(associations_of_the_cabpool)

      expect(cabpool.localities).to eq localities
    end

    it 'adds users in order in which its passed to it' do
      cabpool = build(:cabpool)
      user = build(:user)
      another_user = build(:user, :another_user)
      users = [user, another_user]
      associations_of_the_cabpool = { users: users }

      cabpool.add_associations_in_order(associations_of_the_cabpool)

      expect(cabpool.users).to eq users
    end

    it 'adds users and localities in order in which its passed to it' do
      cabpool = build(:cabpool)
      locality1 = create(:locality, name: 'L1')
      locality2 = create(:locality, name: 'L2')
      localities = [locality1, locality2]
      user = build(:user)
      another_user = build(:user, :another_user)
      users = [user, another_user]
      associations_of_the_cabpool = { localities: localities, users: users }

      expect(cabpool.localities).to receive(:clear)
      cabpool.add_associations_in_order(associations_of_the_cabpool)

      expect(cabpool.users).to eq users
      expect(cabpool.localities).to eq localities
    end
  end

  it 'has validation errors on attributes and not on associations when attributes are invalid' do
    invalid_cabpool = build(:cabpool, :without_time_in)
    invalid_cabpool.users.clear
    invalid_cabpool.localities.clear
    valid_associations = { localities: [build(:locality)], users: [build(:user)] }

    expect(invalid_cabpool.valid_including_associations?(valid_associations)).to be false
    expect(invalid_cabpool.errors.messages.empty?).to be false
    expect(invalid_cabpool.errors[:localities].empty?).to be true
    expect(invalid_cabpool.errors[:users].empty?).to be true
  end

  it 'has validation errors on associations and not on attributes when associations are invalid' do
    invalid_cabpool = build(:cabpool)
    invalid_cabpool.users.clear
    invalid_cabpool.localities.clear
    invalid_associations = { localities: [], users: [] }

    expect(invalid_cabpool.valid_including_associations?(invalid_associations)).to be false
    expect(invalid_cabpool.errors.messages.empty?).to be false
    expect(invalid_cabpool.errors[:timein].empty?).to be true
    expect(invalid_cabpool.errors[:localities].empty?).to be false
    expect(invalid_cabpool.errors[:users].empty?).to be false
  end

  it 'has validation errors on associations and attributes when attributes and associations are invalid' do
    invalid_cabpool = build(:cabpool, :without_time_in)
    invalid_cabpool.users.clear
    invalid_cabpool.localities.clear
    invalid_associations = { localities: [], users: [] }

    expect(invalid_cabpool.valid_including_associations?(invalid_associations)).to be false
    expect(invalid_cabpool.errors.messages.empty?).to be false
    expect(invalid_cabpool.errors[:timein].empty?).to be false
    expect(invalid_cabpool.errors[:localities].empty?).to be false
    expect(invalid_cabpool.errors[:users].empty?).to be false
  end

  describe 'company_provided_cab?' do
    it 'returns true when the cabpool is company provided' do
      cabpool = build(:cabpool, :without_cabpool_type)
      cabpool.cabpool_type = :company_provided_cab

      expect(cabpool.company_provided_cab?).to be true
    end

    it 'returns false when the cabpool is not company provided' do
      cabpool = build(:cabpool, :without_cabpool_type)
      cabpool.cabpool_type = :personal_car

      expect(cabpool.company_provided_cab?).to be false
    end
  end

  describe 'user_is_part_of_cabpool' do
    it 'returns true when a user is part of a cabpool' do
      cabpool = build(:cabpool)
      user = build(:user)
      cabpool.users << [user]

      expect(cabpool.user_is_part_of_cabpool?(user)).to be true
    end

    it 'returns false when a user is not part of a cabpool' do
      cabpool = build(:cabpool)
      user = build(:user)
      another_user = build(:user, :another_user)
      cabpool.users = [another_user]

      expect(cabpool.user_is_part_of_cabpool?(user)).to be false
    end
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

    it 'is L3 L2 L1 when assigned to the cabpool in the same way' do
      @cabpool.localities = [@locality3, @locality2, @locality1]
      @cabpool.save
      expect(@cabpool.ordered_localities).to eq [@locality3, @locality2, @locality1]
    end

    it 'is L1 L2 L3 when assigned to the cabpool in the same way' do
      @cabpool.localities = [@locality1, @locality2, @locality3]
      @cabpool.save
      expect(@cabpool.ordered_localities).to eq [@locality1, @locality2, @locality3]
    end

    it 'is L2 L3 L1 when assigned to the cabpool in the same way' do
      @cabpool.localities = [@locality2, @locality3, @locality1]
      @cabpool.save
      expect(@cabpool.ordered_localities).to eq [@locality2, @locality3, @locality1]
    end
  end
end
