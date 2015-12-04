class StaticPagesController < ApplicationController
  def home
    @username = session[:FirstName].capitalize
    @cabpool = Cabpool.new
  end

  def about
  end

  def contact
  end
end
