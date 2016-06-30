# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  emp_id      :integer
#  name        :string
#  email       :string
#  address     :text
#  locality_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cabpool_id  :integer
#  status      :string
#  phone_no    :string
#  role_id     :integer
#
# Indexes
#
#  index_users_on_cabpool_id   (cabpool_id)
#  index_users_on_emp_id       (emp_id) UNIQUE
#  index_users_on_locality_id  (locality_id)
#  index_users_on_role_id      (role_id)
#
# Foreign Keys
#
#  fk_rails_43d6d9310b  (cabpool_id => cabpools.id)
#  fk_rails_642f17018b  (role_id => roles.id)
#  fk_rails_67d309e01c  (locality_id => localities.id)
#

FactoryGirl.define do
  factory :user do
    emp_id Faker::Number.between(1111, 999999999)
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

  trait :with_large_emp_id do
    emp_id "12345678901"
  end

  trait :with_small_emp_id do
    emp_id "123"
  end

  trait :with_alphabetic_emp_id do
    emp_id "abc"
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
