# frozen_string_literal: true
module SessionsHelper
  def store_location
    if request.get?
      session[:forward_url] = request.url if request.fullpath != '/'
    else
      session.delete(:forward_url)
    end
  end

  def is_logged_in?
    !session[:Email].nil?
  end

  def redirect_back_or(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forward_url)
  end

  def current_user
    email = session[:Email]
    @current_user ||= User.find_by_email(email) unless email.nil?
  end

  def is_admin?
    is_registered? && current_user.role.name == 'admin'
  end

  def is_registered?
    !current_user.nil?
  end
end
