class UsersController < ApplicationController

  def new
    @user = User.new
    @localities = Locality.all.order(:name) << Locality.new(id: -1, name: 'Other')
    session[:FirstName].capitalize!
    session[:LastName].capitalize!
    @user.name = "#{session[:FirstName]} #{session[:LastName]}"
    @user.email = "#{session[:Email]}"
  end

  def create
    @user = User.new(user_params)
    @user.name = "#{session[:FirstName]} #{session[:LastName]}"
    @user.email = "#{session[:Email]}"
    add_new_valid_locality
    if @user.save
      redirect_to @user
    else
      @localities = Locality.all.order(:name) << Locality.new(id: -1, name: 'Other')
      render new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      allowed_params = params.require(:user).permit(:emp_id, :address)
      locality_id = params[:user][:locality]
      locality = Locality.find_by_id(locality_id)
      allowed_params.merge(locality: locality)
    end

    def add_new_valid_locality
      locality_id = params[:user][:locality]
      other_name = params[:user][:other]
      if locality_id == '-1'
        if !other_name.blank?
          new_locality = Locality.new(name: other_name)
          if new_locality.save
            @user.locality = new_locality
            new_locality.destroy if !@user.valid?
          else
            @locality_errors = new_locality.errors.full_messages
          end
        end
      end
    end
end
