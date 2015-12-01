module SessionsHelper

  def store_location
    session[:forward_url] = request.url if request.get?
  end

  def is_logged_in?
    !session[:userid].nil?
  end
end
