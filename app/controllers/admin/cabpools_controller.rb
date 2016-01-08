class Admin::CabpoolsController < Admin::AdminController

  def show
    company_provided_cabpools = Cabpool.where(cabpool_type: CabpoolType.find_by_name("Company provided Cab"))
    @cabpools = company_provided_cabpools
  end

  def new
    @cabpool = Cabpool.new
  end

  def create
    @cabpool = Cabpool.new(cabpool_params)
    add_localities_to_cabpool
    add_users_to_cabpool
    if @cabpool.save
      redirect_to '/admin'
    else
      render 'admin/cabpools/new'
    end
  end


private

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route)
    cabpool_type = CabpoolType.new
    params[:cabpool_type].values.each do |cabpool_type_id|
      cabpool_type = CabpoolType.find_by_id(cabpool_type_id)
    end
    allowed_params.merge(cabpool_type: cabpool_type)
  end

  def add_localities_to_cabpool
    params[:localities].values.each do |locality_id|
      locality = Locality.find_by_id(locality_id)
      @cabpool.localities << locality if !locality.nil?
    end
  end

  def add_users_to_cabpool
    params[:users].values.each do |user_id|
      user = User.find_by_id(user_id)
      @cabpool.users << user if !user.nil?
    end

    if params[:passengers] != nil
      params[:passengers].values.each do |user_id|
        user = User.find_by_id(user_id)
        @cabpool.users << user if !user.nil?
      end
    end
  end
end
