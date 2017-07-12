class PracticeSessionsController < ApplicationController

  def tendencies
  end

  def new
  end

  def create

    # Create a new practice session
    practice = PracticeSession.new
    practice.user_id = current_user.id
    practice.title = params[:practice_title]
    practice.date = params[:practice_date]

    if params[:video_file] != ""
      practice.practice_session_url = params[:video_file]
    else
      practice.practice_session_url = params[:video_url]
    end

    if practice.save!
      redirect_to '/dashboard'
    else
      redirect_to '/practice_sessions/new'
    end
    
  end

  def show
  end

end
