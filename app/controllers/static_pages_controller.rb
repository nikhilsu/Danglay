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

  def show
    @username = session[:FirstName].capitalize
    @cabpool = Cabpool.new
    searched_locality_id = params[:localities].values.first
    locality = Locality.find_by_id(searched_locality_id)
    if locality.nil?
      flash[:danger] = "Select a locality"
      @cabpools = Cabpool.all
    elsif !locality.cabpools.empty?
      @cabpools = locality.cabpools
    else
      flash[:danger] = "Locality has no cabpools"
      @cabpools = Cabpool.all
    end
    render 'home'
  end
end
