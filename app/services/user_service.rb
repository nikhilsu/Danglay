# frozen_string_literal: true
class UserService
  def self.fetch_all_users(user_ids)
    User.where(id: user_ids).all
  end
end
