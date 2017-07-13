class UsersController < ApplicationController

  def home

  end

  def dashboard

  end

  def new
    # new user instance for errors
    @user = User.new
  end

  def create

    @user = User.new
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.team_name = params[:team_name]
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.avatar = "/assets/avatar.svg"
    @user.admin = false
    @user.subscription = 'trial'

    if @user.save
      session[:user_id] = @user.id
      redirect_to '/dashboard'
    else

      render :new
    end

  end

  def show
  end

  def edit
  end

  def update
  end

  def admin
  end

end
