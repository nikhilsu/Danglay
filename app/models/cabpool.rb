class Cabpool < ActiveRecord::Base

  has_and_belongs_to_many :localities
  has_many :users
  belongs_to :locality


  validates_time :timein, :timeout
  validates_numericality_of :number_of_people, less_than_or_equal_to: 4, greater_than_or_equal_to: 1
end
