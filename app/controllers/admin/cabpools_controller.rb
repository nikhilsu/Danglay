class Admin::CabpoolsController < Admin::AdminController
  def show
    @cabpools = Cabpool.find_by_cabpool_type_id(CabpoolType.find_by_name("Company provided Cab"))
  end
end
