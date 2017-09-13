class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :set_cache_headers

  include SessionHelper
  include RouteHelper
  include WoopraHelper

  def auth_current_user
    @auth_current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
