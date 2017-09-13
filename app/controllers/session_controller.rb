class SessionController < ApplicationController


  def new
    @title = "ProScout - Log In"
  end

  def create

    @user = User.find_by(email: params[:email])

    woopra = WoopraTracker.new(request)
    woopra_configure

    if @user
      # Woopra identify visitor logging in
      woopra.identify({
        email: @user.email,
        name: @user.first_name + ' ' + @user.last_name,
        username: @user.username
      })

      # Track login form
      woopra.track("login", {
        first_name: @user.first_name,
        last_name: @user.last_name,
        username: @user.username,
        email: @user.email,
        team_name: @user.team_name
      }, true)
    end

    if @user != nil
      user_authenticate("dashboard/#{@user.username}")
    else
      @error = 'Your Email or Password is not correct'

      render :new
    end
  end

  def destroy

    end_session

  end

end
