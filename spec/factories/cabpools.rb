FactoryGirl.define do
  factory :cabpool do
    number_of_people 4
    timein '9:30'
    timeout '5:30'
    after(:build) do |cabpool|
      3.times do
        cabpool.localities << FactoryGirl.build_stubbed(:locality, name: Faker::Address.street_name)
      end
    end
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

  trait :without_less_than_four_people do
    number_of_people 6
  end

  trait :without_greater_than_one_person do
    number_of_people 0
  end

  trait :timein_in_invalid_format do
    timein '25'
  end

  trait :timein_with_milliseconds do
    timein '11:25:00.010'
  end

  trait :timeout_in_invalid_format do
    timeout '100'
  end

  trait :timeout_with_milliseconds do
    timeout '11:50:10.010'
  end

  trait :time_in_am do
    timeout '09:30'
  end

  trait :time_in_pm do
    timeout '22:30'
  end

  trait :without_localities do
    after(:build) do |cabpool|
      cabpool.localities.clear
    end
  end

  trait :with_duplicate_localities do
    after(:build) do |cabpool|
      cabpool.localities.clear
      l = FactoryGirl.build_stubbed(:locality)
      2.times do
        cabpool.localities << l
      end
    end
  end

  trait :more_than_five_localities do
    after(:build) do |cabpool|
      cabpool.localities.clear
      6.times do
        cabpool.localities << FactoryGirl.build_stubbed(:locality)
      end
    end
  end
end
