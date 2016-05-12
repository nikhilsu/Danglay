class CabpoolsController < ApplicationController
  include CabpoolsHelper
  before_action :registered?, except: [:show, :approve_reject_handler]
  before_action :has_cabpool, only: [:leave, :edit, :update]
  before_action :cabpool_exists_and_user_part_of_it?, only: [:edit, :update]
  before_action :not_company_provided_cabpool?, only: [:edit, :update]
  before_action :user_should_not_have_cabpool, only: :new

  def user_should_not_have_cabpool
    user = current_user
    if !user.nil?
      if user.cabpool
        flash[:danger] = 'You are already part of a Cab pool. Please leave the cabpool to create a new cab pool.'
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
    else
      send_email_to_cabpool_users_on_member_leaving(users, current_user)
      send_email_to_admin_when_user_leaves(users, current_user)
    end
    flash[:success] = 'You have left your cab pool.'
    redirect_to root_url
  end

  def edit
  end

  def update
    @cabpool.attributes = params.require(:cabpool).permit(:number_of_people, :remarks, :timein, :timeout, :route)
    locality_ids = params[:localities].nil? ? [] : params[:localities].values
    associations_of_the_cabpool = {localities: LocalityService.fetch_all_localities(locality_ids)}
    response = CabpoolPersister.new(@cabpool, associations_of_the_cabpool).persist
    if response.success?
      send_email_to_cabpool_members_about_cabpool_update(@cabpool, current_user)
      flash[:success] = 'Your Cabpool has been Updated'
      redirect_to your_cabpools_path and return
    else
      flash[:danger] = 'Cannot update because of the following errors'
      render 'edit'
    end
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    if selected_cabpool_type_is_company_provided_cabpool
      send_email_to_admins_to_request_cabpool_creation(current_user, Time.new(params[:cabpool][:timein]), Time.new(params[:cabpool][:timeout]), params[:remarks])
      flash[:success] = 'You have successfully requested the admins for a cab pool.'
      redirect_to root_path
    else
      locality_ids = params[:localities].nil? ? [] : params[:localities].values
      associations_of_the_cabpool = {localities: LocalityService.fetch_all_localities(locality_ids), users: [current_user]}
      response = CabpoolPersister.new(@cabpool, associations_of_the_cabpool).persist
      if response.success?
        flash[:success] = "You have successfully created your cab pool. Please check the 'MyRide' tab for details."
        redirect_to your_cabpools_path
      else
        flash[:danger] = 'Cannot create because of the following errors'
        render 'new'
      end
    end
  end

  def join
    id = params[:cabpool][:id]
    joining_cabpool = Cabpool.find_by_id(id)
    requesting_user = User.find_by_email(session[:Email])
    if joining_cabpool.available_slots > 0
      flash[:success] = 'Join Request Sent!'
      request = Request.create(user: requesting_user, cabpool: joining_cabpool)
      if joining_cabpool.cabpool_type.name == 'Company provided Cab'
        send_email_to_admins_for_join_request(joining_cabpool, current_user, request.approve_digest)
      else
        send_emails_to_cabpool_users(joining_cabpool, current_user, request.approve_digest)
      end
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
        flash.now[:danger] = 'Select a locality'
        @cabpools = cabpools_to_render(Cabpool.all)
      elsif !locality.cabpools.empty?
        @cabpools = cabpools_to_render(locality.cabpools)
      else
        @cabpools = cabpools_to_render([])
      end
    end
    @cabpools = sort_by_available_slots @cabpools
    @cabpools = @cabpools.paginate(page: params[:page], :per_page => 10)
  end

  def your_cabpools

  end

  def approve_reject_handler
    approve = params[:approve]
    token = params[:token]
    cabpool_id = params[:cabpool]
    user_id = params[:user]
    requesting_user = User.find(user_id)
    approver = User.find_by_id(params[:approver])
    request = Request.find_by(user_id: user_id, cabpool_id: cabpool_id)
    if request.nil?
      render 'request_duplicate'
    else
      digest = request.approve_digest
      if digest == token
        if approve == "true"
          approve_user requesting_user, request, approver
        else
          reject_user requesting_user, request
        end
      else
        render 'request_invalid'
      end
    end
  end

  def approve_via_notification
    requested_users_id = params[:user_id]
    current_user = User.find_by_email(session[:Email])
    requested_user = User.find(requested_users_id)
    request = Request.find_by(user_id: requested_users_id, cabpool_id: current_user.cabpool.id)
    if (current_user.cabpool.requested_users.exists?(:id => requested_users_id))
      approve_user requested_user, request, current_user
    else
      render 'request_invalid'
    end
  end

  def reject_via_notification
    requested_users_id = params[:user_id]
    current_user = User.find_by_email(session[:Email])
    requested_user = User.find(requested_users_id)
    request = Request.find_by(user_id: requested_users_id, cabpool_id: current_user.cabpool.id)
    if (current_user.cabpool.requested_users.exists?(:id => requested_users_id))
      reject_user requested_user, request
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
  def approve_user(user, request, approver)
    if !user.cabpool.nil?
      if user.cabpool.users.length > 1
        send_email_to_cabpool_users_on_member_leaving(user.cabpool.users.reject { |u| u.id == user.id }, user)
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
    send_member_addition_email_to_cabpool_members(approver, user)
    send_email_to_approved_user user
    render 'request_accept'
  end

  def destroy cabpool
    cabpool.users.clear
    cabpool.requests.clear
    cabpool.destroy!
  end

  def send_member_addition_email_to_cabpool_members(approver, user)
    CabpoolMailer.member_addition_to_cabpool(approver, user).deliver_now
  end

  def send_email_to_admin_about_invalid_cabpool deleting_cabpool
    if deleting_cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_invalid_cabpool(deleting_cabpool).deliver_now
    end
  end

  def send_email_to_admins_to_request_cabpool_creation(requesting_user, timein, timeout, remarks)
    CabpoolMailer.admin_notifier_for_new_cabpool_creation_request(requesting_user, timein, timeout, remarks).deliver_now
  end

  def send_email_to_rejected_user(rejected_user)
    CabpoolMailer.cabpool_reject_request(rejected_user).deliver_now
  end

  def send_email_to_admin_when_user_leaves(users, leaving_user)
    cabpool = users.first.cabpool
    if cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_member_leaving(cabpool, leaving_user).deliver_now
    end
  end

  def send_email_to_cabpool_users_on_member_leaving(users, current_user)
    users.collect do |user|
      CabpoolMailer.cabpool_leave_notifier(user, current_user).deliver_now
    end
  end

  def send_email_to_approved_user(approved_user)
    CabpoolMailer.cabpool_approve_request(approved_user).deliver_now
  end

  def send_email_to_cabpool_members_about_cabpool_update(updated_cabpool, member_updating_cabpool)
    CabpoolMailer.member_of_a_cabpool_updated_it(updated_cabpool, member_updating_cabpool).deliver_now
  end

  def send_emails_to_cabpool_users(cabpool, current_user, digest)
    cabpool.users.collect do |user|
      CabpoolMailer.cabpool_join_request(user, cabpool, current_user, digest).deliver_now
    end
  end

  def send_email_to_admins_for_join_request(joining_cab, joining_user, digest)
    CabpoolMailer.admin_notifier_for_join_cabpool(joining_cab, joining_user, digest).deliver_now
  end

  def reject_user(user, request)
    request.destroy!
    user.status = 'rejected'
    user.save
    send_email_to_rejected_user user
    render 'request_reject'
  end

  def registered?
    store_location
    if !is_registered?
      flash[:danger] = 'Please update your profile to create a new cab pool.'
      redirect_to new_user_path
    end
  end

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route, :remarks)
    _, cabpool_type_id = params[:cabpool_type].first if !params[:cabpool_type].nil?
    cabpool_type = CabpoolType.find_by_id(cabpool_type_id)
    if allowed_cabpool_types_for_user.include? cabpool_type
      allowed_params.merge(cabpool_type: cabpool_type)
    end
  end

  def has_cabpool
    if current_user.cabpool.nil?
      flash[:danger] = 'You are not part of a cabpool.'
      redirect_to root_url
    end
  end

  def selected_cabpool_type_is_company_provided_cabpool
    cabpool_type = CabpoolType.new
    params[:cabpool_type].values.each do |cabpool_type_id|
      cabpool_type = CabpoolType.find_by_id(cabpool_type_id)
    end
    if cabpool_type == nil
      return false
    end
    return cabpool_type.name == CabpoolType.find_by_name('Company provided Cab').name
  end

  def not_company_provided_cabpool?
    if @cabpool.is_company_provided?
      flash[:danger] = 'Cannot Edit a Company Provided Cabpool'
      redirect_to root_url
    end
  end

  def cabpool_exists_and_user_part_of_it?
    @cabpool = Cabpool.find_by_id(params[:id])
    if @cabpool.nil? or !@cabpool.user_is_part_of_cabpool? current_user
      flash[:danger] = 'Cannot Edit a cabpool that you are not part of'
      redirect_to root_url
    end
  end
end