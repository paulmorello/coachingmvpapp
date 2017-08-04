class SessionController < ApplicationController


  def new

  end

  def create

    @user = User.find_by(email: params[:email])
    if @user != nil
      user_authenticate("dashboard/#{@user.username}")
    end
  end

  def destroy

    end_session

  end

end
