# frozen_string_literal: true
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :role do
    name 'user'
  end

  trait :admin_role do
    name 'admin'
  end
end
