class ApplicationController < ActionController::Base
  protect_from_forgery
  # force_ssl
  after_filter :customheaders

  # If any controllers raise authentication exceptions, catch them here and
  # respond to the client with a 403 (auth fail) + exception message in the body
  rescue_from CanCan::AccessDenied do |exception|
    render :text => exception.message, :status => 401
  end

  def stat_show
    head :no_content
  end

  private

  # If @current_user is set, returns it else sets and returns
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    raise CanCan::AccessDenied unless current_user
  end
  
  def customheaders
    response.headers['Vary'] = 'Accept'
  end

  # Lets us use current_user in our views and throughout our controllers
  helper_method :current_user
end
