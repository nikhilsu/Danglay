FactoryGirl.define do

  factory :locality do
    name "SomeLocality"

    trait :without_name do
      name ""
    end
  end
end
