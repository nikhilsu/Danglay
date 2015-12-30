module SessionsHelper

  def store_location
    if request.get?
      session[:forward_url] = request.url
    else
      session.delete(:forward_url)
    end
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

  def is_registered?
    !session[:registered_uid].nil?
  end
end
