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

  def user_requested_cabpool_exists?
    if session[:registered_uid].nil?
      false
    else
      user_requested_cabpool = users_requested_cabpool
      !user_requested_cabpool.nil?
    end
  end

  def users_requested_cabpool
    user = User.find_by_email(session[:Email])
    user.requested_cabpools.first
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
      elsif cabpool.available_slots > 0 && !user_requested_cabpool_exists?
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
      cabpools = cabpools.reject { |cabpool| cabpool.id == users_requested_cabpool.id }
    end
    cabpools
  end
end
