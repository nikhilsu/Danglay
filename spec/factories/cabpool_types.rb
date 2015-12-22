FactoryGirl.define do
  factory :cabpool_type do
    name Faker::Name.name
  end

  trait :without_type_name do
    name ""
  end
end
