class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_feature_activated?
    FEATURES.active_action?(params[:controller], params[:action])
  end

  before_filter :check_feature_activated?
end
