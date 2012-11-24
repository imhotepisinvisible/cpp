class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl

  rescue_from CanCan::AccessDenied do |exception|
    render :text => exception.message, :status => 403
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
