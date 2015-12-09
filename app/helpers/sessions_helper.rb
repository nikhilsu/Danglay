module SessionsHelper

  def store_location
    session[:forward_url] = request.url if request.get?
  end

  def is_logged_in?
    !session[:userid].nil?
  end

  def redirect_back_or(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forward_url)
  end

  def current_user
    if email = session[:Email]
      @current_user ||= User.find_by(email: email)
    end
  end
end
