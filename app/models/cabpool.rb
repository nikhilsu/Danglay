class Cabpool < ActiveRecord::Base

  belongs_to :cabpool_type
  has_and_belongs_to_many :localities
  has_many :users
  has_many :requests
  has_many :requested_users, through: :requests, source: :user

  validates_time :timein, :timeout
  validates_numericality_of :number_of_people, less_than_or_equal_to: 4, greater_than_or_equal_to: 1
  validate :invalidate_empty_localities, :invalidate_duplicate_localities, :invalidate_more_than_five_localities,
           :invalidate_empty_cabpool_type, :invalidate_new_number_of_people_being_lesser_than_old_value, :invalidate_empty_users,
           :invalidate_having_more_users_than_capacity, :invalidate_timein_after_timeout
  validates :remarks, length: {maximum: 300}

  def ordered_localities
    return localities.order('cabpools_localities.created_at')
  end

   def available_slots
    number_of_people - users.size
  end

  def get_validation_errors_on_localities localities_to_validate
    cabpool_clone = self.dup
    cabpool_clone.localities = localities_to_validate
    cabpool_clone.validate
    return cabpool_clone.errors[:localities]
  end

  def add_localities_in_order localities_to_add
    self.localities.clear
    self.localities = localities_to_add
  end

  def populate_validation_errors(validation_errors_on_localities)
    self.validate
    self.errors[:localities] = validation_errors_on_localities.first if !validation_errors_on_localities.empty?
  end

  private
  def invalidate_new_number_of_people_being_lesser_than_old_value
    if number_of_people.to_i < number_of_people_was.to_i
      errors.add(:number_of_people, 'Cannot be less than the existing capacity')
    end
  end

  def invalidate_empty_localities
    if localities.empty?
      errors.add(:localities, 'This should not be empty')
    end
  end

  def invalidate_duplicate_localities
    difference = localities.size - localities.uniq.size
    if difference != 0
      errors[:localities] = 'This already Exists.'
    end
  end

  def invalidate_more_than_five_localities
    if localities.length > 5
      errors.add(:localities, "More than 5 localities.")
    end
  end
  def invalidate_empty_cabpool_type
    if cabpool_type.nil?
      errors.add(:cabpool_types, "This should not be empty.")
    end
  end

  def invalidate_empty_users
    if users.length == 0
      errors.add(:users, "This should not be empty")
    end
  end

  def invalidate_having_more_users_than_capacity
    if users.length > number_of_people.to_i
      errors.add(:users, "Users cannot be greater than capacity.")
    end
  end

  def invalidate_timein_after_timeout
    if !timein.nil? and !timeout.nil?
      if timein > timeout
        errors.add(:timein, "cannot be after Departure time.")
      end
    end
  end
end
