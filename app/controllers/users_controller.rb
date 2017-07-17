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
    @user = current_user

  end

  def update
    @user = current_user
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.username = params[:username_new]
    @user.email = params[:email]

    # Check if username field is empty
    if params[:password] != ''
      @user.password = params[:password]
    end

    if @user.save
      @success = "You have successfully updated your account."
      return redirect_to user_path
    end
    render :edit
  end

  def update_payment
  end

  def admin
  end

  def cancel_account
  end

  def destroy

    user = current_user

    if user && user.authenticate(params[:password])
      user.delete
      redirect_to "/confirmation/delete-account"
    else
      redirect_to "/users/#{current_user.username}"
    end
  end

end
