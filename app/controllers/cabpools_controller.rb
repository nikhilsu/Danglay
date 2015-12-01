class CabpoolsController < ApplicationController
  attr_reader :locality

  if FEATURES.active?('create_cabpool_feature')
    def new
      @cabpool = Cabpool.new
      user = User.find_by_email(session[:userid])
      @locality = Locality.find(user.locality_id).name
    end
  end
end
