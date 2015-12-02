class CabpoolsController < ApplicationController

  before_action :registered? , except: [:show]

  attr_reader :locality

  def new
    @cabpool = Cabpool.new
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

  def registered?
    if session[:registered_uid].nil?
      redirect_to new_user_path
    end
  end

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route)
  end
end