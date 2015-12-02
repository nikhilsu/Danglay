class StaticPagesController < ApplicationController
  def home
    @username = session[:FirstName]
  end
end
