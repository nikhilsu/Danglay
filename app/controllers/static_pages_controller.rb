class StaticPagesController < ApplicationController
  def home
    @username = session[:FirstName].capitalize!
  end

  def about
  end
end
