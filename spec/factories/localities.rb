FactoryGirl.define do

  factory :locality do
    name Faker::Address.street_name

    trait :another_locality do
      name 'another_locality'
    end

    trait :without_name do
      name ""
    end
  end
end
