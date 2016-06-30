# == Schema Information
#
# Table name: requests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  cabpool_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  approve_digest :string
#
# Indexes
#
#  index_requests_on_cabpool_id  (cabpool_id)
#  index_requests_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_0f243b45d6  (cabpool_id => cabpools.id)
#  fk_rails_8ead8b1e6b  (user_id => users.id)
#

class Request < ActiveRecord::Base
  attr_accessor :approve_token
  before_create :create_approve_digest
  belongs_to :user
  belongs_to :cabpool
  validates_presence_of  :user, :cabpool

  def Request.new_token
    SecureRandom.urlsafe_base64
  end

  def Request.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def create_approve_digest
    self.approve_token = Request.new_token
    self.approve_digest = Request.digest(approve_token)
  end
end
