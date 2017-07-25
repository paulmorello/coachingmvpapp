class VideosController < ApplicationController

  def new
    redirect_to_route_if_not_logged_in(route = '/login')
  end

  def create
    redirect_to_route_if_not_logged_in(route = '/login')
  end

end
