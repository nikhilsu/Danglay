class Locality < ActiveRecord::Base

  has_and_belongs_to_many :cabpools
  validates :name, presence: true, uniqueness: true
  has_many :users
end