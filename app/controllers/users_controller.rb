# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :not_registered?, only: [:new, :create]

  def new
    @user = User.new
    @localities = localities_for_dropdown
    session[:FirstName].capitalize!
    session[:LastName].capitalize!
    @user.name = "#{session[:FirstName]} #{session[:LastName]}"
    @user.email = session[:Email].to_s
  end

  def create
    @user = User.new(user_params)
    @user.name = "#{session[:FirstName]} #{session[:LastName]}"
    @user.email = session[:Email].to_s
    add_new_valid_locality
    if @user.save
      flash[:success] = 'Your Profile has been updated'
      redirect_back_or(root_path)
    else
      @localities = localities_for_dropdown
      render new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
    @localities = localities_for_dropdown
  end

  def update
    @user = current_user
    @localities = localities_for_dropdown
    add_new_valid_locality
    if @user.update_attributes(user_params_edit)
      flash[:success] = 'Profile updated'
      redirect_to root_path
    else
      render 'edit'
  end
  end

  private

  # TODO: Since this is used only for the view, can we move this into the helper?
  def localities_for_dropdown
    Locality.all.order(:name) << Locality.new(id: -1, name: 'Other')
  end

  def not_registered?
    redirect_to root_path if is_registered?
  end

  def user_params
    allowed_params = params.require(:user).permit(:emp_id, :address, :phone_no)
    locality_id = params[:user][:locality]
    locality = Locality.find_by_id(locality_id)
    allowed_params.merge(locality: locality)
  end

  def user_params_edit
    allowed_params = params.require(:user).permit(:emp_id, :address, :phone_no)
    allowed_params.merge(locality: @user.locality)
  end

  # TODO: This should be done at the model-level
  def add_new_valid_locality
    locality_id = params[:user][:locality]
    other_name = params[:user][:other]
    if locality_id == '-1'
      unless other_name.blank?
        new_locality = Locality.new(name: other_name)
        if new_locality.save
          # TODO: IF this is done within a transaction, we don't need to destroy the just-created record
          @user.locality = new_locality
          new_locality.destroy unless @user.valid?
        else
          @locality_errors = new_locality.errors.full_messages
        end
      end
    else
      @user.locality = Locality.find_by_id(locality_id)
    end
   end
end
