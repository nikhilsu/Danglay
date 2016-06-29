class Locality < ActiveRecord::Base
  has_and_belongs_to_many :cabpools
  validates :name, presence: true, uniqueness: true   # TODO: Case-sensitivity is not validated?
  has_many :users

  # TODO: default order? this is being used as Locality.all.order in some places
end
