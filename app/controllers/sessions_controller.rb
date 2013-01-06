class SessionsController < ApplicationController
  respond_to :json

  def new
    @session = {email: nil, password:nil}
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id

      case user.type
      when "Student"
        redirect_to "/#students/#{user.id}/edit"
      when "CompanyAdministrator"
        redirect_to "/#company_dashboard"
      when "DepartmentAdministrator"
        redirect_to "/#department_dashboard"
      else
        redirect_to root_url
      end

    else
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
