class Cabpool < ActiveRecord::Base

  has_and_belongs_to_many :localities
  has_many :users
  has_many :requests
  has_many :requested_users, through: :requests, source: :user

  validates_time :timein, :timeout
  validates_numericality_of :number_of_people, less_than_or_equal_to: 4, greater_than_or_equal_to: 1
  validate :invalidate_empty_localities, :invalidate_duplicate_localities, :invalidate_more_than_five_localities

  def ordered_localities
    sql = "SELECT locality_id FROM cabpools_localities WHERE cabpool_id = #{id}"
    locality_ids_array = ActiveRecord::Base.connection.execute(sql)
    locality_ids_array.values.flatten.map { |locality_id| Locality.find(locality_id) }
  end

  def invalidate_empty_localities
    if localities.empty?
      errors.add(:localities, "Empty")
    end
  end

  def invalidate_duplicate_localities
    difference = localities.size - localities.uniq.size
    if difference != 0
      errors.add(:localities, "Already Exists")
    end
  end

  def invalidate_more_than_five_localities
    if localities.length > 5
      errors.add(:localities, "More than 5 localities")
    end
  end

  def available_slots
    number_of_people - users.size - requested_users.size
  end
end
