class PasswordResetsController < ApplicationController

  def new
    if !logged_in?
      redirect_to_route_if_not_logged_in(route = '/login')
    else
      redirect_to_route_if_logged_in(route = "/dashboard/#{current_user.username}")
    end

  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to '/', :notice => "Email sent with password reset instructions."
  end

  def edit
    if !logged_in?
      redirect_to_route_if_not_logged_in(route = '/login')
    else
      redirect_to_route_if_logged_in(route = "/dashboard/#{current_user.username}")
    end

    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update

    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago

      redirect_to new_password_reset_path, :alert => "Password reset has expired."

    elsif params["user"]["password"] == params["user"]["password"]
      @user.password = params["user"]["password"]

      if @user.save
        redirect_to '/', :notice => "Password has been reset!"
      end

    else
      render :edit
    end
  end
end
