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
end
