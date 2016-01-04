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

  def is_admin?
      is_registered? && current_user.role.name == 'admin'
  end
end
