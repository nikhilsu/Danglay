# frozen_string_literal: true
class Admin::CabpoolsController < Admin::AdminController
  before_action :company_provided_cabpool?, only: [:edit, :update]

  def show
    company_provided_cabpools = Cabpool.company_provided_cab
    @cabpools = company_provided_cabpools.paginate(page: params[:page], per_page: 10)
  end

  def new
    @cabpool = Cabpool.new
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    user_ids = params[:passengers].nil? ? [] : params[:passengers].values
    locality_ids = params[:localities].nil? ? [] : params[:localities].values
    association_of_cabpool = { localities: LocalityService.fetch_all_localities(locality_ids), users: UserService.fetch_all_users(user_ids) }
    response = CabpoolService.persist(@cabpool, association_of_cabpool)
    if response.success?
      flash[:success] = 'Cabpool creation successful'
      MailService.send_emails_to_cabpool_members_when_admin_creates_a_pool @cabpool
      redirect_to('/admin') && return
    else
      flash[:danger] = response.message
      render 'admin/cabpools/new'
    end
  end

  def edit
  end

  def update
    @cabpool.attributes = params.require(:cabpool).permit(:number_of_people, :remarks, :timein, :timeout, :route)
    members_before_cabpool_update = get_members_before_cabpool_update
    user_ids = params[:passengers].nil? ? [] : params[:passengers].values
    locality_ids = params[:localities].nil? ? [] : params[:localities].values
    associations_of_cabpool = { users: UserService.fetch_all_users(user_ids), localities: LocalityService.fetch_all_localities(locality_ids) }
    response = CabpoolService.persist(@cabpool, associations_of_cabpool)
    if response.success?
      MailService.send_email_to_cabpool_users_about_cabpool_update_by_admin(@cabpool, members_before_cabpool_update)
      flash[:success] = 'Cabpool has been updated'
      redirect_to('/admin') && return
    else
      flash[:danger] = response.message
      render 'edit'
    end
  end

  def delete
    Cabpool.destroy(params[:id])
    flash[:success] = 'Cabpool has been deleted'
    redirect_to '/admin'
  end

  private

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route, :remarks)
    allowed_params.merge(cabpool_type: :company_provided_cab)
  end

  def get_members_before_cabpool_update
    members = []
    # TODO: Can't we use the #collect method here?
    @cabpool.users.each do |user|
      members << user
    end
    members
  end

  def company_provided_cabpool?
    @cabpool = Cabpool.find_by_id(params[:id])
    unless @cabpool.company_provided_cab?
      flash[:danger] = 'Cannot Edit a Non-Company Provided Cabpool'
      redirect_to '/admin'
    end
  end
end
