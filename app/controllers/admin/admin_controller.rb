class Admin::AdminController < ApplicationController
  before_action :authorized_admin?

  def authorized_admin?
    if User.find_by_email(session[:Email]).role.name != "admin"
      render 'custom_errors/not_found_error'
    end
  end

end
