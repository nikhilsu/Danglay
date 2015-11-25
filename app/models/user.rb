class User < ActiveRecord::Base
  belongs_to :locality
  validates_presence_of :emp_id, :name, :email, :address, :locality
end