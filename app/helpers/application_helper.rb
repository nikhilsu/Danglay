require 'sessions_helper'
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Danglay App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def number_of_notifications
    notifications = 0
    if !current_user.cabpool.nil?
      notifications = notifications + current_user.cabpool.requested_users.size
    end
    if !current_user.status.nil?
      notifications = notifications + 1
    end
    notifications
  end
end
