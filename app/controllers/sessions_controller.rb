class SessionsController < ApplicationController
  respond_to :json
  def new
    @session = Session.new
    respond_with @session
  end
  
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      respond_with @session, location: nil
    else
      respond_with @session, status: :unprocessable_entity, location: nil
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
