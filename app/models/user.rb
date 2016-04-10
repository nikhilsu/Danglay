class User < ActiveRecord::Base
  before_create :set_default_role
  belongs_to :locality
  belongs_to :cabpool
  belongs_to :role
  has_many :requests
  has_many :requested_cabpools, through: :requests, source: :cabpool
  validates_presence_of :emp_id, :name, :email, :address, :locality, :phone_no
  validate :validate_phone_no
  validates :emp_id, length: { minimum: 4, maximum:10 },  :numericality => true, uniqueness: true
  validates :emp_id, reduce: true
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

          errors.add(:phone_no, "Phone no should have only numbers and x, ., -, (, +, )")
          return
        end
      end
    else
      errors.add(:phone_no, "Phone no should be of length not more than 25 characters")
    end
  end

  private
  def set_default_role
    self.role ||= Role.find_by_name('user')
  end

end
