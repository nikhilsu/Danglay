# frozen_string_literal: true
class Admin::UsersController < Admin::AdminController
  def new
    @user = User.new
    @localities = localities_for_dropdown
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'The Profile has been updated'
      redirect_to admin_path
    else
      @localities = localities_for_dropdown
      render 'admin/users/new'
    end
  end

  private

  # TODO: Since this is used only for the view, can we move this into the helper?
  def localities_for_dropdown
    Locality.all.order(:name) << Locality.new(id: -1, name: 'Other')
  end

  def user_params
    allowed_params = params.require(:user).permit(:emp_id, :address, :phone_no, :name, :email)
    locality_id = params[:user][:locality]
    # TODO: Why hit the db here, just so that the params hash is populated with a retrieved AR object?
    locality = Locality.find_by_id(locality_id)
    allowed_params.merge(locality: locality)
  end
end
