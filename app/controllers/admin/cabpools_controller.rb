class Admin::CabpoolsController < Admin::AdminController
  before_action :company_provided_cabpool?, only: [:edit, :update]

  def show
    company_provided_cabpools = Cabpool.where(cabpool_type: CabpoolType.find_by_name('Company provided Cab'))
    @cabpools = company_provided_cabpools.paginate(page: params[:page], :per_page => 10)
  end

  def new
    @cabpool = Cabpool.new
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    user_ids = params[:passengers].nil? ? [] : params[:passengers].values
    locality_ids = params[:localities].nil? ? [] : params[:localities].values
    association_of_cabpool = {localities: LocalityService.fetch_all_localities(locality_ids), users: UserService.fetch_all_users(user_ids)}
    response = CabpoolPersister.new(@cabpool, association_of_cabpool).persist
    if response.success?
      flash[:success] = 'Cabpool creation successful'
      MailService.send_emails_to_cabpool_members_when_admin_creates_a_pool @cabpool
      redirect_to '/admin' and return
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
    associations_of_cabpool = {users: UserService.fetch_all_users(user_ids), localities: LocalityService.fetch_all_localities(locality_ids)}
    response = CabpoolPersister.new(@cabpool, associations_of_cabpool).persist
    if response.success?
      MailService.send_email_to_cabpool_users_about_cabpool_update_by_admin(@cabpool, members_before_cabpool_update)
      flash[:success] = 'Cabpool has been Updated'
      redirect_to '/admin' and return
    else
      flash[:danger] = response.message
      render 'edit'
    end
  end


  def delete
    cabpool = Cabpool.find(params[:id])
    destroy cabpool
    flash[:success] = 'Cabpool has been Deleted'
    redirect_to '/admin'
  end

  private

  def destroy cabpool
    cabpool.users.clear
    cabpool.requests.clear
    cabpool.destroy!
  end

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route, :remarks)
    cabpool_type = CabpoolType.find_by_name('Company provided Cab')
    allowed_params.merge(cabpool_type: cabpool_type)
  end

  def get_members_before_cabpool_update
    members = []
    @cabpool.users.each do |user|
      members << user
    end
    return members
  end

  def company_provided_cabpool?
    @cabpool = Cabpool.find_by_id(params[:id])
    if !@cabpool.is_company_provided?
      flash[:danger] = 'Cannot Edit a Non-Company Provided Cabpool'
      redirect_to '/admin'
    end
  end
end