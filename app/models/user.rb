# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  emp_id      :integer
#  name        :string
#  email       :string
#  address     :text
#  locality_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cabpool_id  :integer
#  status      :string
#  phone_no    :string
#  role_id     :integer
#
# Indexes
#
#  index_users_on_cabpool_id   (cabpool_id)
#  index_users_on_emp_id       (emp_id) UNIQUE
#  index_users_on_locality_id  (locality_id)
#  index_users_on_role_id      (role_id)
#
# Foreign Keys
#
#  fk_rails_43d6d9310b  (cabpool_id => cabpools.id)
#  fk_rails_642f17018b  (role_id => roles.id)
#  fk_rails_67d309e01c  (locality_id => localities.id)
#

class User < ActiveRecord::Base
  before_create :set_default_role

  belongs_to :locality
  belongs_to :cabpool
  belongs_to :role
  has_many :requests
  has_many :requested_cabpools, through: :requests, source: :cabpool

  validates :emp_id, :name, :email, :address, :locality, :phone_no, presence: true
  validate :validate_phone_no
  validates :emp_id, length: { minimum: 4, maximum: 10 }, numericality: true, uniqueness: true
  validates :emp_id, reduce: true
  attr_readonly :emp_id

  private

  # TODO: Can this be a single-line validates method/macro call using format? Or can this be done with a gem?
  def validate_phone_no
    return if phone_no.nil?

    if phone_no.length < 25
      allowed_chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '.', '(', ')', ' ', 'x']
      for character in phone_no.split('')
        next if character.in?(allowed_chars)

        errors.add(:phone_no, 'Phone no should have only numbers and x, ., -, (, +, )')
        return
      end
    else
      errors.add(:phone_no, 'Phone no should be of length not more than 25 characters')
    end
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('user')
  end
end
