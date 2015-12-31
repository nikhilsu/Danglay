class User < ActiveRecord::Base
  belongs_to :locality
  belongs_to :cabpool
  has_many :requests
  has_many :requested_cabpools, through: :requests, source: :cabpool
  validates_presence_of :emp_id, :name, :email, :address, :locality, :phone_no
  validate :only_one_request, :validate_phone_no
  attr_readonly :emp_id

  private

  def validate_phone_no
    if phone_no.nil?
      return
    end

    if phone_no.length < 25
      allowed_chars = ['0','1','2','3','4','5','6','7','8','9','+','-','.','(',')',' ','x']
      for character in phone_no.split("")
        if !(character.in?(allowed_chars))
          errors.add(:users, "Phone no should have only numbers and x, ., -, (, +, )")
          return
        end
      end
    else
      errors.add(:users, "Phone no should be of length not more than 25 characters")
    end
  end

  def only_one_request
    if requests.size > 1
      errors.add(:requests, "Already requested")
    end
  end

end
