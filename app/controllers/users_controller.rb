class UsersController < ApplicationController

  before_action :not_registered? , only: [:new, :create]

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
      set_registered_uid
      flash[:success] = "Your Profile has been updated"
      redirect_back_or(root_path)
    else
      @localities = Locality.all.order(:name) << Locality.new(id: -1, name: 'Other')
      render new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
    @localities = Locality.all.order(:name) << Locality.new(id: -1, name: 'Other')
  end

  def update
    @user = current_user
    @localities = Locality.all.order(:name) << Locality.new(id: -1, name: 'Other')
      if (@user.update_attributes(user_params))
        flash[:success] = "Profile updated"
        redirect_to root_path
    else
      render 'edit'
    end
  end

  private

    def not_registered?
      unless session[:registered_uid].nil?
        redirect_to root_path
      end
    end

    def set_registered_uid
      user =  User.find_by_email(@user.email)
      session[:registered_uid] = user.id
    end

    def user_params
      allowed_params = params.require(:user).permit(:emp_id, :address, :phone_no)
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
