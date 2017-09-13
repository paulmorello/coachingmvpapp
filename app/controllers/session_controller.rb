class SessionController < ApplicationController


  def new
    @title = "ProScout - Log In"
  end

  def create

    @user = User.find_by(email: params[:email])

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
