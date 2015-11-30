class User < ActiveRecord::Base
  belongs_to :locality
  belongs_to :cabpool
  validates_presence_of :emp_id, :name, :email, :address, :locality
end