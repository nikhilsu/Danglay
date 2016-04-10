class ReduceValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if !record.errors.messages.has_key?(attribute)
      return
    elsif record.errors[attribute].size > 1
      record.errors[attribute].slice!(1..-1)
    end
  end
end