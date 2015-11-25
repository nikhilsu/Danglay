class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save

    else
      render 'new'
    end
  end

  private

  def user_params
    allowed_params = params.require(:user).permit(:name, :emp_id, :email, :address)
    locality = Locality.find_by(name: params[:locality])
    allowed_params.merge(locality: locality)
  end
end