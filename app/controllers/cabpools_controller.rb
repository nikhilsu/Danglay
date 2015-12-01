class CabpoolsController < ApplicationController
  attr_reader :locality

  def new
    @cabpool = Cabpool.new
    user = User.find_by_email(session[:userid])
    @locality = Locality.find(user.locality_id).name
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    if @cabpool.save
      render 'cabpools/show'
    else
      render 'cabpools/new'
    end
  end

  private

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route)
    locality_id = Locality.find_by_name(@locality)
    allowed_params.merge(locality_id: locality_id)
  end

end
