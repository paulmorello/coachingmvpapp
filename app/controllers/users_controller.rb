class UsersController < ApplicationController

  def home

  end

  def dashboard
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def new
    redirect_to_route_if_logged_in(route = 'dashboard')

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

      sleep 3
        redirect_to '/confirmation/payment-confirmed'
    else

      render :new
    end

  end

  def show
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def edit
    redirect_to_route_if_not_logged_in(route = 'login')

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
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def confirm_payment
  end

  def cancel_account
    redirect_to_route_if_not_logged_in(route = 'login')
  end

  def delete_account
  end

  def destroy

    user = current_user

    if user && user.username == params[:username]
      user.delete
      sleep 3
        redirect_to "/confirmation/delete-account"
    else
      sleep 3
        redirect_to "/users/#{current_user.username}"
    end
  end

  # Admin pages for game and page reviews
  def admin
    redirect_to_route_if_not_logged_in(route = 'login')
    # is_not_admin?(route = 'dashboard')

    @games = Game.where(needs_review: true).limit(10)
    @game_total = @games.count

    @practice = PracticeSession.where(needs_review: true).limit(10)
    @practice_total = @practice.count
  end

  def game_reviews
    redirect_to_route_if_not_logged_in(route = 'login')
    # is_not_admin?(route = 'dashboard')

    offset = 0
    @games = Game.where(needs_review: true).limit(25).offset(offset)
  end

  def practice_reviews
    redirect_to_route_if_not_logged_in(route = 'login')
    # is_not_admin?(route = 'dashboard')

    offset = 0
    @practice = PracticeSession.where(needs_review: true).limit(25)
  end

end
