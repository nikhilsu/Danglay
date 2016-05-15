class LocalityService
  def self.fetch_all_localities(locality_ids)
    localities = []
    locality_ids.each do |locality_id|
      locality = Locality.find_by_id(locality_id)
      localities << locality if !locality.nil?
    end
    return localities
  end
end