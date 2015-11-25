FactoryGirl.define do

  factory :locality do
    name Faker::Address.street_name

    trait :without_name do
      name ""
    end
  end
end
