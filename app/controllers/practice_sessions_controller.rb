class PracticeSessionsController < ApplicationController

  def tendencies
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def confirmation
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def index
    redirect_to_route_if_not_logged_in(route = 'login')
    redirect_to '/tendencies'

  end

  def new
    redirect_to_route_if_not_logged_in(route = 'login')

    # creating instance of practice session for errors
    @practice = PracticeSession.new
  end

  def create

    # Create a new practice session
    @practice = PracticeSession.new
    @practice.user_id = current_user.id
    @practice.title = params[:practice_title]
    @practice.date = params[:practice_date]
    @practice.needs_review = true

    if params[:video_file] != ""
      @practice.practice_session_url = params[:video_file]
    else
      @practice.practice_session_url = params[:video_url]
    end

    if @practice.save
      redirect_to '/practice/confirmation'
    else
      render :new
    end

  end

  def show
    redirect_to_route_if_not_logged_in(route = 'login')
    is_not_admin?(route = 'dashboard')

    @practice = PracticeSession.find_by(id: params[:id])
    @user = User.find_by(id: @practice.user_id)

    # Finding past reviewed games
    @previous_practices = PracticeSession.where("needs_review = ? AND user_id = ?", false, @user.id)

  end

  def admin_review
    redirect_to_route_if_not_logged_in(route = 'login')
    is_not_admin?(route = 'dashboard')

    @practice = PracticeSession.find_by(id: params[:id])
    @user = User.find_by(id: @practice.user_id)
  end

end
