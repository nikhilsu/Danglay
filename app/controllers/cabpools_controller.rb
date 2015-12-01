class CabpoolsController < ApplicationController
  attr_reader :locality

  def new
    @cabpool = Cabpool.new
    user = User.find_by_email(session[:userid])
   @locality = Locality.find(user.locality_id).name
  end
end
