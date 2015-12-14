class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  include SessionsHelper

  if FEATURES.active?('okta_feature')
    before_action :authorized? , except: [:init, :consume, :approve_reject_handler]
  end
  before_action :set_user_name, except: [:init, :consume, :approve_reject_handler]
  before_filter :check_feature_activated?

  def authorized?
    if session[:userid].nil?
      store_location
      redirect_to '/saml/init'
    end
  end

  def check_feature_activated?
    FEATURES.active_action?(params[:controller], params[:action])
  end

  def set_user_name
    @username = session[:FirstName].capitalize
  end
end
