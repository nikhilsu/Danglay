class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    allowed_params = params.require(:user).permit(:name, :emp_id, :email, :address, :locality)
    locality = Locality.find_by_id(params[:user][:locality])
    allowed_params.merge(locality: locality)
  end
end
