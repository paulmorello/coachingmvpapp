class SessionController < ApplicationController

  def new

  end

  def create

    @user = User.find_by(email: params[:email])
    user_authenticate('events')

  end

  def destroy

    end_session

  end

end
