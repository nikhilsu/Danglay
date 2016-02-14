class CabpoolsController < ApplicationController
  include CabpoolsHelper
  before_action :registered? , except: [:show, :approve_reject_handler]
  before_action :has_cabpool, only: [:leave]
  before_action :has_cabpool_or_request, only: [:your_cabpools]
  before_action :user_should_not_have_cabpool, only: :new

  def user_should_not_have_cabpool
    user = User.find_by_email(session[:Email])
    if !user.nil?
       if user.cabpool
         flash[:danger] = "You are already part of a Cab pool. Please leave the cabpool to create a new cab pool."
         redirect_to your_cabpools_path
       end
    end
  end

  def new
    @cabpool = Cabpool.new
  end

  def leave
    current_user_cabpool = current_user.cabpool
    current_user.cabpool = nil
    current_user.save
    users = current_user_cabpool.users
    if current_user_cabpool.users.size == 0
      current_user_cabpool.destroy
    elsif current_user_cabpool.users.size == 1
      send_email_to_admin_about_invalid_cabpool(current_user_cabpool)
      send_email_to_cabpool_users_on_member_leaving(users, current_user)
    else
      send_email_to_cabpool_users_on_member_leaving(users, current_user)
      send_email_to_admin_when_user_leaves(users, current_user)
    end
    flash[:success] = "You have left your cab pool."
    redirect_to root_url
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    add_localities_to_cabpool
    add_session_user_to_cabpool
    if @cabpool.save
      flash[:success] = "You have successfully created your cab pool. Please check the 'MyRide' tab for details."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def join
    id = params[:cabpool][:id]
    joining_cab = Cabpool.find_by_id(id)
    requesting_user = User.find_by_email(session[:Email])
    if joining_cab.available_slots > 0
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
    @cabpools = sort_by_available_slots @cabpools
  end

  def your_cabpools

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


  def approve_via_notification
    requested_users_id = params[:user_id]
    user = User.find_by_email(session[:Email])
    requested_user = User.find(requested_users_id)
    if (user.cabpool.requested_users.exists?(:id => requested_users_id))
      approve_user requested_user
    else
      render 'request_invalid'
    end
  end

  def reject_via_notification
    requested_users_id = params[:user_id]
    user = User.find_by_email(session[:Email])
    requested_user = User.find(requested_users_id)
    if (user.cabpool.requested_users.exists?(:id => requested_users_id))
        reject_user requested_user
      else
        render 'request_invalid'
      end
  end

  def view_notification
    user = current_user
    if user.status == "approved"
      user.status = nil
      user.save!
      redirect_to your_cabpools_path
    else
        if user.status == "rejected"
          user.status = nil
          user.save!
        end
        redirect_to root_path
    end
  end

  private

  def approve_user user
    request = Request.find_by_user_id(user.id)
    if !user.cabpool.nil?
      if user.cabpool.users.length > 1
        send_email_to_cabpool_users_on_member_leaving(user.cabpool.users.reject { |u| u.id == user.id } ,user)
      else
        destroy user.cabpool
      end
    end
    user.cabpool = request.cabpool
    user.status = 'approved'
    user.save
    request.user.requests.each do |req|
      req.destroy!
    end
    send_email_to_approved_user user

    if request.cabpool.users.count == 2
       send_email_to_admin_about_new_cabpool user
    else
       send_email_to_admin_about_new_user user
    end
    render 'request_accept'
  end

  def destroy cabpool
    cabpool.users.clear
    cabpool.requests.clear
    cabpool.destroy!
  end

  def send_email_to_admin_about_new_user joining_user
    if joining_user.cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_new_user(joining_user).deliver_now
    end
  end

  def send_email_to_admin_about_new_cabpool joining_user
    if joining_user.cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_new_cabpool(joining_user).deliver_now
    end
  end

  def send_email_to_admin_about_invalid_cabpool deleting_cabpool
    if deleting_cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_invalid_cabpool(deleting_cabpool).deliver_now
    end
  end

  def reject_user user
    request = Request.find_by_user_id(user.id)
    request.destroy!
    user.status = 'rejected'
    user.save
    send_email_to_rejected_user user
    render 'request_reject'
  end

  def send_email_to_rejected_user(rejected_user)
    CabpoolMailer.cabpool_approve_request(rejected_user).deliver_now
  end

  def send_email_to_admin_when_user_leaves(users, leaving_user)
    cabpool = users.first.cabpool
    if cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_member_leaving(cabpool, leaving_user).deliver_now
    end
  end

  def send_email_to_cabpool_users_on_member_leaving(users,current_user)
    users.collect do |user|
      CabpoolMailer.cabpool_leave_notifier(user,current_user).deliver_now
    end
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
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route, :remarks)
    cabpool_type = CabpoolType.new
    params[:cabpool_type].values.each do |cabpool_type_id|
      cabpool_type = CabpoolType.find_by_id(cabpool_type_id)
    end
    if cabpool_types_for_user.include? cabpool_type
      allowed_params.merge(cabpool_type: cabpool_type)
    end
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

  def has_cabpool_or_request
    if current_user.cabpool.nil? && current_user.requested_cabpools.empty?
      redirect_to root_path
      flash[:danger] = "You are not part of any cab pool. Please create or join a cab pool."
    end
  end

end
