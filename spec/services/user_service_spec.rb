# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserService, type: :service do
  it 'gets all the users using the ids' do
    user1 = build(:user)
    user2 = build(:user, :another_user)
    expect(User).to receive(:find_by_id).with(1).and_return(user1)
    expect(User).to receive(:find_by_id).with(2).and_return(user2)

    users = described_class.fetch_all_users([1, 2])

    expect(users).to eq [user1, user2]
  end

  it 'gets only those users that exist' do
    user1 = build(:user)
    expect(User).to receive(:find_by_id).with(1).and_return(user1)
    expect(User).to receive(:find_by_id).with(2).and_return(nil)

    users = described_class.fetch_all_users([1, 2])

    expect(users).to eq [user1]
  end
end
