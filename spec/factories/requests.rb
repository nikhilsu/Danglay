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

FactoryGirl.define do
  factory :request do
    association :user, factory: :user, strategy: :build
    association :cabpool, factory: :cabpool, strategy: :build
  end

  trait :without_user do
    user nil
  end

  trait :without_cabpool do
    cabpool nil
  end
end
