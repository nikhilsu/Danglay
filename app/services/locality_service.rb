# frozen_string_literal: true
class LocalityService
  def self.fetch_all_localities(locality_ids)
    Locality.where(id: locality_ids).all
  end
end
