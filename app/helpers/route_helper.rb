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
    if logged_in?
      @user = current_user
      if @user == nil || !@user.admin
        redirect_to ("/#{route}")
      end
    end
  end

  def not_allowed_access?
    if @user != nil
      if @user.username != params[:username]
        redirect_to "/dashboard/#{current_user.username}"
      end
    end
  end

end
