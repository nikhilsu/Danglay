FactoryGirl.define do
  factory :user do
    emp_id 1
    name Faker::Name.name
    email Faker::Internet.email
    address Faker::Address.secondary_address
    locality
  end

  trait :another_user do
    locality {FactoryGirl.build(:locality, :another_locality)}
  end

  trait :without_name do
    name ""
  end

  trait :without_emp_id do
    emp_id ""
  end

  trait :without_email do
    email ""
  end

  trait :without_address do
    address ""
  end

  trait :without_locality do
    locality nil
  end
end
