class SessionController < ApplicationController


  def new
    redirect_to_route_if_logged_in(route = 'dashboard')

  end

  def create

    @user = User.find_by(email: params[:email])
    user_authenticate('dashboard')

  end

  def destroy

    end_session

  end

end
