module SessionHelper

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def end_session
    cookies.delete :user_id
    session[:user_id] = nil
    redirect_to '/'
  end

  def user_authenticate(route = '')

    if @user && @user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
      session[:user_id] = @user.id
      redirect_to "/#{route}"
    else
      @error = 'Your Email or Password is not correct'
      
      render :new
    end

  end

end
