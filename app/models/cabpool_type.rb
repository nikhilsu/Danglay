class CabpoolType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :cabpools
end
