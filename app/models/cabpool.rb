class Cabpool < ActiveRecord::Base

  has_many :users
  belongs_to :locality

  validates_time :timein, :timeout
  validates_presence_of :route
  validates_numericality_of :number_of_people, less_than_or_equal_to: 4, greater_than_or_equal_to: 1
end
