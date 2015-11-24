FactoryGirl.define do
  factory :user do
    emp_id 1
    name "SomeName"
    email "someemail@random.com"
    address "Some Address"
    association :locality, factory: :locality
  end

  factory :user_without_name, class: User do
    emp_id 2
    name ""
    email "someemail@random.com"
    address "Some Address"
    association :locality, factory: :locality
  end
end
