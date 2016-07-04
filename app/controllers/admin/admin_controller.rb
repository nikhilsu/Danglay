# frozen_string_literal: true
class Admin::AdminController < ApplicationController
  before_action :authorized_admin?

  def authorized_admin?
    render 'custom_errors/not_found_error' if current_user.nil? || current_user.role.name != 'admin'
  end
end
