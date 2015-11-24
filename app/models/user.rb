class User < ActiveRecord::Base
  belongs_to :locality
  validates_presence_of :emp_id
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :address
  validates_presence_of :locality_id
end