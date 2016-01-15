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
    if current_user.status.nil?
      current_user.cabpool.requested_users.size
    else
      current_user.cabpool.requested_users.size + 1
    end
  end
end
