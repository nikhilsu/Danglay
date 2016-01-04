FactoryGirl.define do
  factory :user do
    emp_id 1
    name Faker::Name.name
    email Faker::Internet.email
    address Faker::Address.secondary_address
    phone_no Faker::PhoneNumber.phone_number
    association :locality, factory: :locality, strategy: :build
  end

  trait :existing_user do
    email 'vdeepika@thoughtworks.com'
  end

  trait :another_user do
    locality { FactoryGirl.build(:locality, :another_locality) }
  end

  trait :yet_another_user do
    locality { FactoryGirl.build(:locality, :another_locality) }
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

  trait :without_phone_no do
    phone_no nil
  end

  trait :greater_than_25_phone_no do
    phone_no "01234567891011121314151617"
  end

  trait :invalid_chars_phone_no do
    phone_no "+91 456 xaaa56"
  end

  trait :with_admin_role do
    association :role, factory: [:role, :admin_role], strategy: :build
  end

end
