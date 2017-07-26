class DrillsController < ApplicationController

  def index
    redirect_to_route_if_not_logged_in(route = 'login')
  end

  def new
    redirect_to_route_if_not_logged_in(route = 'login')
    is_not_admin?(route = 'dashboard')

  end

end
