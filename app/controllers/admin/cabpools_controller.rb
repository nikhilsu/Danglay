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
    if(no_passengers_added)
      flash[:danger] = "Please add some people to the cab"
      render 'admin/cabpools/new'
    elsif (passengers_are_greater_than_capacity)
      flash[:danger] = "Number of people are more than the capacity of the cab"
      render 'admin/cabpools/new'
    else
      if @cabpool.save
        redirect_to '/admin'
      else
        render 'admin/cabpools/new'
      end
    end
  end

  def edit
    @cabpool = Cabpool.find(params[:id])
  end

  def update
    @cabpool = Cabpool.find(params[:id])
    add_users_to_cabpool
    if @cabpool.save
      redirect_to '/admin'
    else
      redirect_to "/admin_cabpool/#{params[:id]}/edit"
    end
  end

private

  def cabpool_params
    allowed_params = params.require(:cabpool).permit(:number_of_people, :timein, :timeout, :route)
    cabpool_type = CabpoolType.find_by_name('Company provided Cab')
    allowed_params.merge(cabpool_type: cabpool_type)
  end

  def add_localities_to_cabpool
    params[:localities].values.each do |locality_id|
      locality = Locality.find_by_id(locality_id)
      @cabpool.localities << locality if !locality.nil?
    end
  end

  def add_users_to_cabpool
    if params[:passengers] != nil
      params[:passengers].values.each do |user_id|
        user = User.find_by_id(user_id)
        @cabpool.users << user if !user.nil?
      end
    end
  end

  def no_passengers_added
    params[:passengers] == nil || params[:passengers].values.first.empty?
  end

  def passengers_are_greater_than_capacity
    (params[:passengers].length > params[:cabpool][:number_of_people].to_i) && (params[:cabpool][:number_of_people].to_i > 0)
  end
end
