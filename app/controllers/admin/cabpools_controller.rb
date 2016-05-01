class Admin::CabpoolsController < Admin::AdminController

  def show
    company_provided_cabpools = Cabpool.where(cabpool_type: CabpoolType.find_by_name('Company provided Cab'))
    @cabpools = company_provided_cabpools.paginate(page: params[:page], :per_page => 10)
  end

  def new
    @cabpool = Cabpool.new
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    association_of_cabpool = {localities: get_localities_of_cabpool_from_params, users: get_members_of_cabpool_from_params}
    response = CabpoolPersister.new(@cabpool, association_of_cabpool).persist
    if response.success?
      flash[:success] = 'Cabpool creation successful'
      send_email_to_cabpool_users @cabpool
      redirect_to '/admin' and return
    else
      flash[:danger] = response.message
      render 'admin/cabpools/new'
    end
  end

  def edit
    @cabpool = Cabpool.find_by_id(params[:id])
  end

  def update
    @cabpool = Cabpool.find_by_id(params[:id])
    @cabpool.remarks = params[:cabpool][:remarks]
    @cabpool.number_of_people = params[:cabpool][:number_of_people]
    members_before_cabpool_update = get_members_before_cabpool_update
    associations_of_cabpool = {users: get_members_of_cabpool_from_params}
    response = CabpoolPersister.new(@cabpool, associations_of_cabpool).persist
    if response.success?
      send_email_to_cabpool_users_about_cabpool_update_by_admin(@cabpool, members_before_cabpool_update)
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

  def send_email_to_cabpool_users cabpool
    cabpool.users.collect do |user|
      CabpoolMailer.cabpool_is_created(user, cabpool).deliver_now
    end
  end

  def send_email_to_cabpool_users_about_cabpool_update_by_admin(cabpool, members_before_cabpool_update)
    members_needing_update_email = cabpool.users | members_before_cabpool_update
    members_needing_update_email.collect do |user|
      CabpoolMailer.cabpool_updated_by_admin(user, members_needing_update_email).deliver_now
    end
  end

  def get_members_of_cabpool_from_params
    members_of_cabpool = []
    params[:passengers].values.each do |user_id|
      user = User.find_by_id(user_id)
      members_of_cabpool << user if !user.nil?
    end
    return members_of_cabpool
  end

  def get_localities_of_cabpool_from_params
    localities_to_be_added = []
    params[:localities].values.each do |locality_id|
      locality = Locality.find_by_id(locality_id)
      localities_to_be_added << locality if !locality.nil?
    end
    return localities_to_be_added
  end
end