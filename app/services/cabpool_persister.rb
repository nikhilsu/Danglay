require 'response'
class CabpoolPersister
  def initialize(cabpool, associations_of_cabpool)
    @cabpool = cabpool
    @associations_of_cabpool = associations_of_cabpool
  end

  def persist
    if @cabpool.valid_including_associations? @associations_of_cabpool
      @cabpool.add_associations_in_order @associations_of_cabpool
       if @cabpool.save
         return Success.new(@cabpool, 'Operation Successful')
       end
    end
    return Failure.new(@cabpool, 'Cannot persist cabpool because of the following validation errors')
  end
end