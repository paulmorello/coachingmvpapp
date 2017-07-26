class StatsController < ApplicationController

  def index
    redirect_to_route_if_not_logged_in(route = 'login')
  end

end
