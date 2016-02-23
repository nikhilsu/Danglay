module CabpoolsHelper

  def formatted_time(time)
    formatted_time = ''
    if (time.hour == 0)
      formatted_time += time.advance(hours: 12).to_formatted_s(:time) + " AM"
    elsif (time.hour < 12)
      formatted_time += time.to_formatted_s(:time) + " AM"
    elsif (time.hour > 12)
      formatted_time += time.change(hour: time.hour - 12, min: time.min).to_formatted_s(:time) + " PM"
    else
      formatted_time += time.to_formatted_s(:time) + " PM"
    end
  end

  def requested_user?(cabpool)
    if session[:registered_uid].nil?
      false
    else
      user = User.find_by_email(session[:Email])
      user.requested_cabpools.include?(cabpool)
    end
  end

  def image_to_be_displayed cabpool
    if cabpool.cabpool_type_id == 1
       "tw.png"
    elsif cabpool.cabpool_type_id == 2
       "ola.png"
    else
       "carpool.png"
    end
  end

  def destination
    "Koramangala"
  end

  def user_cabpool_exists?
    if session[:registered_uid].nil?
      false
    else
      user_cabpool = users_cabpool
      !user_cabpool.nil?
    end
  end

  def received_response_for_cabpool_request?
    user = User.find_by_email(session[:Email])
    !user.status.nil?
  end

  def is_not_a_company_provided_cabpool?(cabpool)
    cabpool_type = cabpool.cabpool_type
    cabpool_type.name != "Company provided Cab"
  end

  def user_requested_cabpool_exists?
    if session[:registered_uid].nil?
      false
    else
      user_requested_cabpool = users_requested_cabpool
      !user_requested_cabpool.empty?
    end
  end

  def users_requested_cabpool
    user = User.find_by_email(session[:Email])
    user.requested_cabpools
  end

  def users_cabpool
    user = User.find_by_email(session[:Email])
    user.cabpool
  end

  def button(cabpool)
    if is_registered?
      if requested_user?(cabpool)
        "Requested"
      elsif current_user.cabpool == cabpool
        "Leave Ride"
      elsif cabpool.available_slots > 0
        "Join Ride"
      end
    else
      if cabpool.available_slots > 0
        "Join Ride"
      end
    end
  end

  def cabpools_to_render(cabpools)
    if user_cabpool_exists?
      cabpools = cabpools.reject { |cabpool| cabpool.id == users_cabpool.id }
    end
    if user_requested_cabpool_exists?
      requested_cabpools = users_requested_cabpool
      requested_cabpools.each do |requested_cabpool|
        cabpools = cabpools.reject { |cabpool| cabpool.id == requested_cabpool.id }
      end
    end
    cabpools
  end

  def cabpool_types_for_user
    cabpool_types = CabpoolType.all
    cabpool_types = cabpool_types.reject { |cabpool_type| cabpool_type.name == 'Company provided Cab' }
  end

  def sort_by_available_slots cabpools
    cabpools.sort_by { |cabpool| cabpool.available_slots }.reverse
  end

  def confirm_message_for_the_current_users_join_request requesting_cabpool
    if current_user.nil?
      return "You cannot request for a cabpool till you Update your profile."
    end
    current_users_cabpool = current_user.cabpool
    if !current_users_cabpool.nil?
      if current_users_cabpool.users.size == 1
        return "Are you sure you want to join this cabpool? Confirming would mean that your existing cabpool will be deleted if your request is accepted."
      else
        return "Are you sure you want to join this cabpool? Confirming would mean that you would be taken out of your existing cabpool if your request is accepted."
      end
    end
    if requesting_cabpool.cabpool_type.name == 'Company provided Cab'
      return "Are you sure you want to join this cabpool? This would send a request to the ADMIN."
    else
      return "Are you sure you want to join this cabpool? This would send a request to all members of cabpool"
    end
  end
end
