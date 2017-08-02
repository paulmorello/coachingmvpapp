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
    is_not_admin?(route = "dashboard/#{current_user.username}")

    @practice = PracticeSession.find_by(id: params[:id])
    @user = User.find_by(id: @practice.user_id)

    # Finding past reviewed games
    @previous_practices = PracticeSession.where("needs_review = ? AND user_id = ?", false, @user.id)

  end

  def admin_review
    redirect_to_route_if_not_logged_in(route = 'login')
    is_not_admin?(route = "dashboard/#{current_user.username}")

    @practice = PracticeSession.find_by(id: params[:id])
    @user = User.find_by(id: @practice.user_id)
  end

  def complete_review

    # Updating user and Practice session properties
    @practice = PracticeSession.find_by(id: params[:practice_id])
    @user = User.find_by(id: params[:user_id])

    # update practice session id
    @user.practice_session_id = @practice.id

    # Update practice properties
    @practice.focus = params[:focus]
    @practice.pratice_notes = params[:practice_notes]
    @practice.additional_notes = params[:additional_notes]

    if @user.save
      @practice.needs_review = false
      if @practice.save
        redirect_to '/admin/complete-practice-review/confirmed'
      else
        redirect_to "/admin/practice/#{@practice.id}/show/admin-review"
      end
    end
  end

  def confirm_complete_review
    redirect_to_route_if_not_logged_in(route = 'login')
    is_not_admin?(route = "dashboard/#{current_user.username}")

  end

end
