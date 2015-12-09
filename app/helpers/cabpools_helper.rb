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
      user.status == 'Requested' && user.cabpool == cabpool
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

  def users_cabpool
    user =  User.find_by_email(session[:Email])
    user.cabpool
  end

  def cabpools_to_render()
    if user_cabpool_exists?
      user_cabpool = users_cabpool
      Cabpool.where.not(id: user_cabpool.id)
    else
      Cabpool.all
    end
  end
end
