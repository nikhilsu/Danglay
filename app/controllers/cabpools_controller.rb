class CabpoolsController < ApplicationController
  include CabpoolsHelper
  before_action :registered? , except: [:show, :approve_reject_handler]
  before_action :has_cabpool, only: [:leave]

  def new
    @cabpool = Cabpool.new
  end

  def leave
    current_user_cabpool = current_user.cabpool
    current_user.cabpool = nil
    current_user.save
    current_user_cabpool.destroy if current_user_cabpool.users.size == 0
    flash[:success] = "You have left your cab pool."
    redirect_to root_url
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
      request = Request.create(user: requesting_user, cabpool: joining_cab)
      send_emails_to_cabpool_users(joining_cab.users, current_user, request.approve_digest)
    else
      flash[:danger] = 'Cab capacity exceeded!'
    end
    redirect_to root_path
  end

  def show
    if params[:localities].nil?
      @cabpools = cabpools_to_render(Cabpool.all)
    else
      searched_locality_id = params[:localities].values.first
      locality = Locality.find_by_id(searched_locality_id)
      if locality.nil?
        flash.now[:danger] = "Select a locality"
        @cabpools = cabpools_to_render(Cabpool.all)
      elsif !locality.cabpools.empty?
        @cabpools = cabpools_to_render(locality.cabpools)
      else
        flash.now[:danger] = "Locality has no cabpools"
        @cabpools = cabpools_to_render(Cabpool.all)
      end
    end
  end

  def approve_reject_handler
    approve = params[:approve]
    token = params[:token]
    user_id = params[:user]
    user = User.find(user_id)
    request = Request.find_by_user_id(user_id)
    if request.nil?
      render 'request_duplicate'
    else
      digest = request.approve_digest
      if digest == token
        if approve == "true"
          approve_user user
        else
          reject_user user
        end
      else
        render 'request_invalid'
      end
    end
  end

  private

  def reject_user user
    Request.find_by_user_id(user.id).destroy!
    send_email_to_rejected_user user
    render 'request_reject'
  end

  def send_email_to_rejected_user(rejected_user)
    CabpoolMailer.cabpool_approve_request(rejected_user).deliver_now
  end

  def approve_user user
    request = Request.find_by_user_id(user.id)
    user.cabpool = request.cabpool
    user.status = 'Approved'
    user.save
    request.destroy!
    send_email_to_approved_user user
    render 'request_accept'
  end

  def send_email_to_approved_user(approved_user)
    CabpoolMailer.cabpool_approve_request(approved_user).deliver_now
  end

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

  def send_emails_to_cabpool_users(users, current_user, digest)
    users.collect do |user|
      CabpoolMailer.cabpool_join_request(user, current_user, digest).deliver_now
    end
  end

  def has_cabpool
    if current_user.cabpool.nil?
      redirect_to root_url
    end
  end
end