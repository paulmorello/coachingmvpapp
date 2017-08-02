class VideosController < ApplicationController

  def new
    redirect_to_route_if_not_logged_in(route = 'login')
    redirect_to_route_if_logged_in('/')
  end

  def create
    redirect_to_route_if_not_logged_in(route = 'login')
    redirect_to_route_if_logged_in('/')
  end

end
