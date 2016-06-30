# frozen_string_literal: true
class LocalityService
  # TODO: isn't this creating an 'n+1' call to the db?
  def self.fetch_all_localities(locality_ids)
    localities = []
    locality_ids.each do |locality_id|
      locality = Locality.find_by_id(locality_id)
      localities << locality unless locality.nil?
    end
    localities
  end
end
