module CabpoolsHelper

  def formatted_time(time)
    formatted_time = ''
    if(time.hour == 0)
      formatted_time += time.advance(hours: 12).to_formatted_s(:time) + " AM"
    elsif(time.hour < 12)
      formatted_time += time.to_formatted_s(:time) + " AM"
    elsif(time.hour > 12)
      formatted_time += time.change(hour: time.hour - 12, min: time.min).to_formatted_s(:time) + " PM"
    else
      formatted_time += time.to_formatted_s(:time) + " PM"
    end
  end

  def requested_user?(cabpool)
    if session[:registered_uid].nil?
      false
    else
      user =  User.find_by_email(session[:Email])
      user.requested_cabpools.include?(cabpool)
    end
  end

  def destination
    "Kormangala"
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
    user =  User.find_by_email(session[:Email])
    user.requested_cabpools.first
  end

  def users_cabpool
    user =  User.find_by_email(session[:Email])
    user.cabpool
  end

  def cabpools_to_render
    cabpools = Cabpool.all
    if user_cabpool_exists?
      cabpools = cabpools.reject { |cabpool| cabpool.id ==  users_cabpool.id}
    end
    if user_requested_cabpool_exists?
      cabpools = cabpools.reject { |cabpool| cabpool.id ==  users_requested_cabpool.id}
    end
    cabpools
  end
end
