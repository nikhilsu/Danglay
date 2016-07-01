# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserService, type: :service do
  it 'gets all the users using the ids' do
    user1 = build(:user)
    user2 = build(:user, :another_user)
    mock_users = double('mock users')
    expect(User).to receive(:where).with(id: [1, 2]).and_return(mock_users)
    expect(mock_users).to receive(:all).and_return([user1, user2])

    users = described_class.fetch_all_users([1, 2])

    expect(users).to eq [user1, user2]
  end

  it 'gets only those users that exist' do
    user1 = build(:user)
    mock_users = double('mock users')
    expect(User).to receive(:where).with(id: [1, 2]).and_return(mock_users)
    expect(mock_users).to receive(:all).and_return([user1])

    users = described_class.fetch_all_users([1, 2])

    expect(users).to eq [user1]
  end
end
