class UserService

  def self.fetch_all_users(user_ids)
    users = []
    user_ids.each do |user_id|
      user = User.find_by_id(user_id)
      users << user if !user.nil?
    end
    return users
  end
end