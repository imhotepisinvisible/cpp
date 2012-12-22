module ApplicationHelper
  def lipsum(*args)
    require 'lorem'
    Lorem::Base.new(*args).output
  end

  def settings_path
    return '' unless current_user

    case current_user.type
    when 'Student'
      return "#students/#{current_user.id}/settings"
    else
      return ''
    end
  end

  def profile_path
    return '' unless current_user

    case current_user.type
    when 'Student'
      return "#students/#{current_user.id}"
    else
      return ''
    end
  end
end
