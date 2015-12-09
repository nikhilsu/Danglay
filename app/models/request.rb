class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :cabpool
  validates_presence_of  :user, :cabpool
end
