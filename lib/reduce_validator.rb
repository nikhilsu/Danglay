# frozen_string_literal: true
class ReduceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    if !record.errors.messages.key?(attribute)
      return
    elsif record.errors[attribute].size > 1
      record.errors[attribute].slice!(1..-1)
    end
  end
end
