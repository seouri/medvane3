# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :find_bibliome
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def is_iphone_request?
    request.user_agent =~ /(Mobile\/.+Safari)/
  end

private
  def find_bibliome
    @bibliome = Bibliome.find(params[:bibliome_id]) if params[:bibliome_id]
  end
end
