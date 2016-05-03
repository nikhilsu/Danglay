require 'rails_helper'

RSpec.describe UserService, type: :service do

  it 'should get all the users using the ids' do
    user1 = build(:user)
    user2 = build(:user, :another_user)
    expect(User).to receive(:find_by_id).with(1).and_return(user1)
    expect(User).to receive(:find_by_id).with(2).and_return(user2)

    users = UserService.fetch_all_users([1, 2])

    expect(users).to eq [user1, user2]
  end

  it 'should get only those users that exist' do
    user1 = build(:user)
    expect(User).to receive(:find_by_id).with(1).and_return(user1)
    expect(User).to receive(:find_by_id).with(2).and_return(nil)

    users = UserService.fetch_all_users([1, 2])

    expect(users).to eq [user1]
  end
end