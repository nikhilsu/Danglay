# frozen_string_literal: true
require 'response'
class CabpoolService
  # TODO: ALL places where this is invoked, we are loading a bunch of locality objects from the db based on some id array.
  #  Why not pass the array here, and call LocalityService from here?
  def self.persist(cabpool, associations_of_cabpool)
    if cabpool.valid_including_associations? associations_of_cabpool
      cabpool.add_associations_in_order associations_of_cabpool
      return Success.new(cabpool, 'Operation Successful') if cabpool.save
    end
    Failure.new(cabpool, 'Cannot persist cabpool because of the following validation errors')
  end

  def self.fetch_all_cabpools_of_a_particular_locality(locality_ids_hash)
    if locality_ids_hash.nil?
      Success.new(Cabpool.all, 'Success')
    elsif locality_ids_hash.values.first.blank?
      Failure.new(Cabpool.all, 'Select a locality')
    else
      locality = Locality.find_by_id(locality_ids_hash.values.first)
      Success.new(locality.cabpools, 'Success')
    end
  end
end
