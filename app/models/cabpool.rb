class Cabpool < ActiveRecord::Base

  attr_accessor :localities_attributes

  has_and_belongs_to_many :localities
  has_many :users

  validates_time :timein, :timeout
  validates_numericality_of :number_of_people, less_than_or_equal_to: 4, greater_than_or_equal_to: 1
  accepts_nested_attributes_for :localities, :reject_if => lambda { |locality| locality[:content].blank? }, :allow_destroy => true
end
