class StaticPagesController < ApplicationController
  def home
    @username = session[:FirstName].capitalize
  end
end
