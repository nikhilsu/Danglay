# == Schema Information
#
# Table name: localities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do

  factory :locality do
    name Faker::Address.street_name

    trait :another_locality do
      name 'another_locality'
    end

    trait :without_name do
      name ''
    end
  end
end
