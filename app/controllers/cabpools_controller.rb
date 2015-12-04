class CabpoolsController < ApplicationController

  before_action :registered? , except: [:show]

  def new
    @cabpool = Cabpool.new
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    add_localities_to_cabpool
    add_session_user_to_cabpool
    if @cabpool.save
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

  def registered?
    store_location
    if session[:registered_uid].nil?
      flash[:danger] = "Please update your profile to create a new cab pool."
      redirect_to new_user_path
    end
  end

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout)
  end

  def add_session_user_to_cabpool
    user = User.find_by_id(session[:registered_uid])
    @cabpool.users << user if !user.nil?
  end

  def add_localities_to_cabpool
      params[:localities].values.each do |locality_id|
        locality = Locality.find_by_id(locality_id)
        @cabpool.localities << locality if !locality.nil?
      end
  end
end