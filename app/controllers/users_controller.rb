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
    allowed_params = params.require(:user).permit(:name, :emp_id, :email, :address)
    locality_id = params[:user][:locality]
    other_name = params[:user][:other]
    if locality_id == '-1' && !other_name.blank?
      other_locality = Locality.create(name: other_name);
      return allowed_params.merge(locality: other_locality)
    end
    locality = Locality.find_by_id(locality_id)
    allowed_params.merge(locality: locality)
  end
end
