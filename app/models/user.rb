class User < ActiveRecord::Base
  belongs_to :locality
  belongs_to :cabpool
  has_many :requests
  has_many :requested_cabpools, through: :requests, source: :cabpool
  validates_presence_of :emp_id, :name, :email, :address, :locality, :phone_no
  validate :only_one_request

  def only_one_request
    if requests.size > 1
      errors.add(:requests, "Already requested")
    end
  end
end