class Admin::AdminController < ApplicationController

  before_action :authorized_admin?

  def authorized_admin?
    if current_user.nil? or current_user.role.name != 'admin'
      render 'custom_errors/not_found_error'
    end
  end
end