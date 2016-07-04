# frozen_string_literal: true
class CabpoolsController < ApplicationController
  include CabpoolsHelper
  before_action :registered?, except: [:show, :approve_reject_handler]
  before_action :has_cabpool, only: [:leave, :edit, :update]
  before_action :cabpool_exists_and_user_part_of_it?, only: [:edit, :update]
  before_action :not_company_provided_cabpool?, only: [:edit, :update]
  before_action :user_should_not_have_cabpool, only: :new

  def user_should_not_have_cabpool
    user = current_user
    if user.present? && user.cabpool
      flash[:danger] = 'You are already part of a Cab pool. Please leave the cabpool to create a new cab pool.'
      redirect_to your_cabpools_path
    end
  end

  def new
    @cabpool = Cabpool.new
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    if @cabpool.company_provided_cab?
      MailService.send_email_to_admins_to_request_cabpool_creation(current_user, Time.new(params[:cabpool][:timein]), Time.new(params[:cabpool][:timeout]), params[:remarks])
      flash[:success] = 'You have successfully requested the admins for a cab pool.'
      redirect_to root_path
    else
      locality_ids = params[:localities].nil? ? [] : params[:localities].values
      associations_of_the_cabpool = { localities: LocalityService.fetch_all_localities(locality_ids), users: [current_user] }
      response = CabpoolService.persist(@cabpool, associations_of_the_cabpool)
      if response.success?
        flash[:success] = 'You have successfully created your cab pool.'
        redirect_to your_cabpools_path
      else
        flash[:danger] = 'Cannot create because of the following errors'
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    @cabpool.attributes = params.require(:cabpool).permit(:number_of_people, :remarks, :timein, :timeout, :route)
    locality_ids = params[:localities].nil? ? [] : params[:localities].values
    associations_of_the_cabpool = { localities: LocalityService.fetch_all_localities(locality_ids) }
    response = CabpoolService.persist(@cabpool, associations_of_the_cabpool)
    if response.success?
      MailService.send_email_to_cabpool_members_about_cabpool_update(@cabpool, current_user)
      flash[:success] = 'Your Cabpool has been Updated'
      redirect_to(your_cabpools_path) && return
    else
      flash[:danger] = 'Cannot update because of the following errors'
      render 'edit'
    end
  end

  def show
    response = CabpoolService.fetch_all_cabpools_of_a_particular_locality(params[:localities])
    flash[:danger] = response.message unless response.success?
    cabpools_to_render = remove_current_users_cabpool(response.data)
    sorted_cabpools = sort_by_available_seats_in_cabpool cabpools_to_render
    @cabpools = sorted_cabpools.paginate(page: params[:page], per_page: 10)
  end

  def join
    joining_cabpool = Cabpool.find_by_id(params[:cabpool][:id])
    requesting_user = User.find_by_email(session[:Email])
    if joining_cabpool.available_slots > 0
      request = Request.create(user: requesting_user, cabpool: joining_cabpool)
      flash[:success] = 'Join Request Sent!'
      MailService.send_emails_to_notify_join_request(joining_cabpool, current_user, request.approve_digest)
    else
      flash[:danger] = 'Cab capacity exceeded!'
    end
    redirect_to root_path
  end

  def leave
    current_user_cabpool = current_user.cabpool
    current_user.cabpool = nil
    current_user.save
    users = current_user_cabpool.users
    if current_user_cabpool.users.empty?
      current_user_cabpool.destroy
    elsif current_user_cabpool.users.size == 1
      MailService.send_email_to_admin_about_invalid_cabpool(current_user_cabpool)
    else
      MailService.send_email_to_cabpool_users_on_member_leaving(users, current_user)
      MailService.send_email_to_admin_when_user_leaves(users, current_user)
    end
    flash[:success] = 'You have left your cab pool.'
    redirect_to root_url
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
        if approve == 'true'
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
    if current_user.cabpool.requested_users.exists?(id: requested_users_id)
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
    if current_user.cabpool.requested_users.exists?(id: requested_users_id)
      reject_user requested_user, request
    else
      render 'request_invalid'
    end
  end

  def view_notification
    user = current_user
    if user.status == 'approved'
      user.status = nil
      user.save!
      redirect_to your_cabpools_path
    else
      if user.status == 'rejected'
        user.status = nil
        user.save!
      end
      redirect_to root_path
    end
  end

  private

  def approve_user(user, request, approver)
    unless user.cabpool.nil?
      if user.cabpool.users.length > 1
        MailService.send_email_to_cabpool_users_on_member_leaving(user.cabpool.users.reject { |u| u.id == user.id }, user)
      else
        destroy user.cabpool
      end
    end
    user.cabpool = request.cabpool
    user.status = 'approved'
    user.save
    request.user.requests.each(&:destroy!)
    MailService.send_member_addition_email_to_cabpool_members(approver, user)
    MailService.send_email_to_approved_user user
    render 'request_accept'
  end

  # TODO: Will this not be done if cascading deletion at the model level?
  def destroy(cabpool)
    cabpool.users.clear
    cabpool.requests.clear
    cabpool.destroy!
  end

  def reject_user(user, request)
    request.destroy!
    user.status = 'rejected'
    user.save
    MailService.send_email_to_rejected_user user
    render 'request_reject'
  end

  def registered?
    store_location
    unless is_registered?
      flash[:danger] = 'Please update your profile to create a new cab pool.'
      redirect_to new_user_path
    end
  end

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route, :remarks)
    _, cabpool_type_id = params[:cabpool_type].first unless params[:cabpool_type].nil?
    # TODO: Why hit the db so as to populate the params hash with a retrieved obj instead of its id?
    cabpool_type = get_cabpool_type_by_id(cabpool_type_id)
    allowed_params.merge!(cabpool_type: cabpool_type)
  end

  def has_cabpool
    if current_user.cabpool.nil?
      flash[:danger] = 'You are not part of a cabpool.'
      redirect_to root_url
    end
  end

  def not_company_provided_cabpool?
    if @cabpool.company_provided_cab?
      flash[:danger] = 'Cannot Edit a Company Provided Cabpool'
      redirect_to root_url
    end
  end

  def cabpool_exists_and_user_part_of_it?
    @cabpool = Cabpool.find_by_id(params[:id])
    if @cabpool.nil? || !@cabpool.user_is_part_of_cabpool?(current_user)
      flash[:danger] = 'Cannot Edit a cabpool that you are not part of'
      redirect_to root_url
    end
  end
end
