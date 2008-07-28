# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  # authenticate before everything
  # http://railscasts.com/episodes/82-http-basic-authentication
  before_filter :authenticate
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'ccc9c664165959c0723fd5f9fdea80eb'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at, :order_lines]
  end
  
  
  protected
  
  # authenticate with HTTP BASIC
  # http://railscasts.com/episodes/82-http-basic-authentication
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG['username'] && 
      password == APP_CONFIG['password']
    end
  end
  
end
