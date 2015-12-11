class CabpoolsController < ApplicationController
  include CabpoolsHelper
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

  def join
    id = params[:cabpool][:id]
    joining_cab = Cabpool.find_by_id(id)
    requesting_user = User.find_by_email(session[:Email])
    if !requesting_user.requests.empty?
      flash[:danger] = 'You have already requested to a cab. Please wait for the request to be processed'
    elsif joining_cab.available_slots != 0
      flash[:success] = 'Request Sent!'
      Request.create(user: requesting_user, cabpool: joining_cab)
      send_emails_to_cabpool_users(joining_cab.users, current_user)
    else
      flash[:danger] = 'Cab capacity exceeded!'
    end
    redirect_to root_path
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
    params.require(:cabpool).permit(:number_of_people, :timein, :timeout)
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

  def send_emails_to_cabpool_users(users, current_user)
    users.collect do |user|
      CabpoolMailer.cabpool_join_request(user, current_user).deliver_now
    end
  end
end