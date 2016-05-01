FactoryGirl.define do
  factory :cabpool_type do
    name Faker::Name.name
  end

  trait :without_type_name do
    name ''
  end

  trait :company_provided_cab do
    name 'Company provided Cab'
    end

  trait :personal_car do
    name 'Personal car'
  end
end
