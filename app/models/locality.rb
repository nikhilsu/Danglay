# frozen_string_literal: true
# == Schema Information
#
# Table name: localities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Locality < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :cabpools

  validates :name, presence: true, uniqueness: true, case_sensitive: false

  default_scope { order(:name) }
end
