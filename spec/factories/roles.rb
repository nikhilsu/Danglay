FactoryGirl.define do
  factory :role do
    name "user"
  end

  trait :admin_role do
    name "admin"
  end
end
