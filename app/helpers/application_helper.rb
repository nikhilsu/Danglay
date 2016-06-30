# frozen_string_literal: true
require 'sessions_helper'
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Danglay App'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def number_of_notifications
    notifications = 0
    current_users_cabpool = current_user.cabpool
    unless current_users_cabpool.nil?
      notifications += current_users_cabpool.requested_users.size
    end
    notifications += 1 unless current_user.status.nil?
    notifications
  end
end
