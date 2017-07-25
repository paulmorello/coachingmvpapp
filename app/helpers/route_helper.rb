module RouteHelper

  def redirect_to_route_if_logged_in(route = '')
    if logged_in?
      redirect_to "/#{route}"
    end
  end

  def redirect_to_route_if_not_logged_in(route = '')
    if !logged_in?
      redirect_to "/#{route}"
    end
  end

  def is_not_admin?(route = '')
    @user = current_user
    if !@user.admin
      redirect_to "/#{route}"
    end
  end

end
