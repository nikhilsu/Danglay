FactoryGirl.define do
  factory :cabpool do
    route "MyString"
    number_of_people 1
    timein '9:30'
    timeout '5:30'
    locality nil
  end

  trait :without_number_of_people do
    number_of_people nil
  end

  trait :without_time_in do
    timein ''
  end

  trait :without_time_out do
    timeout ''
  end

  trait :without_routes do
    route ''
  end

  trait :without_less_than_four_people do
    number_of_people 6
  end

  trait :without_greater_than_one_person do
    number_of_people 0
  end

  trait :timein_in_invalid_format do
    timein '25:50'
  end

  trait :timeout_in_invalid_format do
    timeout '100'
  end
end
