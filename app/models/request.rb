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
