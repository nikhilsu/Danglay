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
