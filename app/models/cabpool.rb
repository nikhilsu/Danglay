# frozen_string_literal: true
# == Schema Information
#
# Table name: cabpools
#
#  id               :integer          not null, primary key
#  number_of_people :integer
#  timein           :time
#  timeout          :time
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  route            :string
#  remarks          :string
#  cabpool_type     :integer
#

class Cabpool < ActiveRecord::Base
  enum cabpool_type: { company_provided_cab: 1, external_cab: 2, personal_car: 3 }

  has_and_belongs_to_many :localities
  has_many :users
  has_many :requests
  has_many :requested_users, through: :requests, source: :user

  validates_time :timein, :timeout
  validates :number_of_people, numericality: { less_than_or_equal_to: 6, greater_than_or_equal_to: 1 }
  validate :invalidate_empty_localities, :invalidate_duplicate_localities, :invalidate_more_than_five_localities,
           :invalidate_empty_cabpool_type, :invalidate_empty_users, :invalidate_having_more_users_than_capacity,
           :invalidate_timein_after_timeout, :invalidate_duplicate_users
  validates :remarks, length: { maximum: 300 }

  def ordered_localities
    localities.unscope(:order).order('cabpools_localities.created_at')
  end

  def available_slots
    number_of_people - users.size
  end

  def valid_including_associations?(associations_to_validate)
    validate
    associations_to_validate.each do |association_name, association_value|
      errors[association_name].clear
      add_validation_errors_on_association(association_name, association_value)
    end
    errors.messages.blank? || errors.messages.values.uniq.join.blank?
  end

  def add_associations_in_order(associations_of_the_cabpool)
    associations_of_the_cabpool.each do |association_name, association_value|
      if association_name == :users
        self.users = association_value
      elsif association_name == :localities
        localities.clear
        self.localities = association_value
      end
    end
  end

  def user_is_part_of_cabpool?(user)
    users.include?(user)
  end

  private

  def add_validation_errors_on_association(association_name, association_to_validate)
    cabpool_clone = dup
    cabpool_clone.send("#{association_name}=", association_to_validate)
    cabpool_clone.validate
    unless cabpool_clone.errors[association_name].blank?
      errors[association_name] = cabpool_clone.errors[association_name].first
    end
  end

  def invalidate_empty_localities
    errors.add(:localities, 'Localities cannot be empty') if localities.empty?
  end

  def invalidate_duplicate_localities
    difference = localities.size - localities.uniq.size
    errors[:localities] = 'Duplicate Localities entered' if difference != 0
  end

  def invalidate_more_than_five_localities
    if localities.length > 5
      errors.add(:localities, 'Cannot have more than 5 localities.')
    end
  end

  # TODO: validates_presence_of?
  def invalidate_empty_cabpool_type
    errors.add(:cabpool_type, 'This should not be empty.') if cabpool_type.nil?
  end

  # TODO: validates_presence_of?
  def invalidate_empty_users
    errors.add(:users, 'Users Cannot be empty') if users.empty?
  end

  def invalidate_having_more_users_than_capacity
    if users.length > number_of_people.to_i
      errors.add(:number_of_people, 'Lesser than Number of Current Users')
    end
  end

  def invalidate_duplicate_users
    difference = users.size - users.uniq.size
    errors.add(:users, 'Duplicate User entered') if difference != 0
  end

  def invalidate_timein_after_timeout
    errors.add(:timein, 'cannot be after Departure time.') if timein.present? && timeout.present? && timein > timeout
  end
end
