class Cabpool < ActiveRecord::Base

  has_many :users
  belongs_to :locality

  # validates_format_of :timein, with: /([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]/, :on => :create
  # validates_format_of :timeout, with: /([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]/, :on => :create
  validates_presence_of :number_of_people, :timein, :timeout, :route
  validates_numericality_of :number_of_people, less_than_or_equal_to: 4, greater_than_or_equal_to: 1
end
