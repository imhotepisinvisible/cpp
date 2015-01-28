module ApplicationHelper
  def lipsum(*args)
    require 'lorem'
    Lorem::Base.new(*args).output
  end

  def settings_path
    return '' unless current_user

    case current_user.type
    when 'Student'
      return "students/#{current_user.id}/settings"
    when 'CompanyAdministrator'
      return "companies/#{current_user.company_id}/settings"
    when 'DepartmentAdministrator'
      return "department_settings"
    else
      return ''
    end
  end

  def profile_path
    return '' unless current_user

    case current_user.type
    when 'Student'
      return "students/#{current_user.id}"
    when 'CompanyAdministrator'
      return "companies/#{current_user.company_id}"
    when 'DepartmentAdministrator'
      return ''
    else
      return ''
    end
  end

  def edit_path
    return '' unless current_user

    case current_user.type
    when 'Student'
      return 'edit'
    when 'CompanyAdministrator'
      return "companies/#{current_user.company_id}/edit"
    when 'DepartmentAdministrator'
      return "department_dashboard"
    else
      return ''
    end
  end
end
