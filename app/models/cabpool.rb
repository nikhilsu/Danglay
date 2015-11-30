class Cabpool < ActiveRecord::Base
  has_many :users
  belongs_to :locality
end
