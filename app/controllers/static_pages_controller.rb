class StaticPagesController < ApplicationController
  def home
    @username = session[:FirstName].capitalize
    @cabpool = Cabpool.new
    @cabpools = Cabpool.all
  end

  def about
  end

  def contact
  end
end
