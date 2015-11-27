class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_action :authorized? , except: [:init, :consume]
  before_filter :check_feature_activated?

  def authorized?
    if session[:userid].nil?
      redirect_to '/saml/init'
    end
  end

  def check_feature_activated?
    FEATURES.active_action?(params[:controller], params[:action])
  end
end
