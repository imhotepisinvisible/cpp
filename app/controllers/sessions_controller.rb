class SessionsController < ApplicationController
  respond_to :json

  # Create new session
  #
  def new
    @session = {email: nil, password:nil}
  end

  # Create new session for a user
  #
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id

      case user.type
      when "Student"
        redirect_to "/"
      when "CompanyAdministrator"
        redirect_to "/"
      when "DepartmentAdministrator"
        redirect_to "/"
      else
        redirect_to root_url, :alert => "Invalid user type"
      end

    else
      redirect_to root_url, :alert => "Username/Password Incorrect"
    end
  end

  # End session, log out
  #
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
