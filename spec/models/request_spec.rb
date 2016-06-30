# frozen_string_literal: true
# == Schema Information
#
# Table name: requests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  cabpool_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  approve_digest :string
#
# Indexes
#
#  index_requests_on_cabpool_id  (cabpool_id)
#  index_requests_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_0f243b45d6  (cabpool_id => cabpools.id)
#  fk_rails_8ead8b1e6b  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Request, type: :model do
  # TODO: Rewrite with shoulda-matchers gem so that these become one-liners

  it 'has a user' do
    request = build(:request, :without_user)
    expect(request.valid?).to be false
  end

  it 'has a cabpool' do
    request = build(:request, :without_cabpool)
    expect(request.valid?).to be false
  end

  it 'creates a valid request' do
    request = build(:request)
    expect(request.valid?).to be true
  end

  it 'saves approve token and digest' do
    request = described_class.new
    request.user = User.first
    request.cabpool = Cabpool.first
    request.save
    expect(request.approve_token).to be_truthy
    expect(request.approve_digest).to be_truthy
  end
end
