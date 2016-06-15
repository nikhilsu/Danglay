module CabpoolsHelper

  def formatted_time(time)
    formatted_time = ''
    if (time.hour == 0)
      formatted_time += time.advance(hours: 12).to_formatted_s(:time) + ' AM'
    elsif (time.hour < 12)
      formatted_time += time.to_formatted_s(:time) + ' AM'
    elsif (time.hour > 12)
      formatted_time += time.change(hour: time.hour - 12, min: time.min).to_formatted_s(:time) + ' PM'
    else
      formatted_time += time.to_formatted_s(:time) + ' PM'
    end
  end

  def image_to_be_displayed cabpool
    if cabpool.company_provided_cab?
      'thoughtworks.png'
    elsif cabpool.external_cab?
      'external.png'
    else
      'personal.png'
    end
  end

  def destination
    'Koramangala'
  end

  def user_cabpool_exists?
    user_cabpool = users_cabpool
    !user_cabpool.nil?
  end

  def received_response_for_cabpool_request?
    !current_user.status.nil?
  end

  def user_requested_cabpool_exists?
    user_requested_cabpool = current_users_requested_cabpool
    !user_requested_cabpool.empty?
  end

  def current_users_requested_cabpool
    user = current_user
    if !user.nil?
      user.requested_cabpools
    else
      []
    end
  end

  def users_cabpool
    user = current_user
    if !user.nil?
      user.cabpool
    end
  end

  def button_info(cabpool)
    if !cabpool.nil?
      if current_users_requested_cabpool.include?(cabpool)
        return { name: 'Requested', disabled: true }
      elsif users_cabpool == cabpool
        return { name: 'Leave Ride', disabled: false }
      elsif cabpool.available_slots > 0
        return {name: 'Join Ride', disabled: false}
      elsif cabpool.available_slots <= 0
        return {name: 'Ride Full', disabled: true}
      end
    end
  end

  def remove_current_users_cabpool(cabpools)
    if user_cabpool_exists?
      cabpools = cabpools.reject { |cabpool| cabpool.id == users_cabpool.id }
    end
    return cabpools
  end

  def get_cabpool_type_by_id(cabpool_type_id)
    cabpool_cabpool_types_key = Cabpool.cabpool_types.key(cabpool_type_id.to_i)
    cabpool_cabpool_types_key.to_sym if cabpool_cabpool_types_key
  end

  def sort_by_available_seats_in_cabpool(cabpools)
    cabpools.sort_by { |cabpool| cabpool.available_slots }.reverse
  end

  def confirm_message_for_the_current_users_join_request(requesting_cabpool)
    current_users_cabpool = current_user.cabpool
    if !current_users_cabpool.nil?
      if current_users_cabpool.users.size == 1
        return 'Are you sure you want to join this cabpool? Confirming would mean that your existing cabpool will be deleted if your request is accepted.'
      else
        return 'Are you sure you want to join this cabpool? Confirming would mean that you would be taken out of your existing cabpool if your request is accepted.'
      end
    end
    if requesting_cabpool.company_provided_cab?
      return 'Are you sure you want to join this cabpool? This would send a request to the ADMIN.'
    else
      return 'Are you sure you want to join this cabpool? This would send a request to all members of cabpool'
    end
  end

  def cabpool_type_that_was_retained
    if params[:cabpool_type].nil?
      return nil
    else
      return params[:cabpool_type].values.first
    end
  end

  def displayable cabpool_id
    cabpool_id + 100 if !cabpool_id.nil?
  end
end
