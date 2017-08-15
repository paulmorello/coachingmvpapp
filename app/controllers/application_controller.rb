class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  include SessionHelper
  include RouteHelper

  def auth_current_user
    @auth_current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

end
