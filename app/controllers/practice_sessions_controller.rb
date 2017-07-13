class PracticeSessionsController < ApplicationController

  def tendencies
  end

  def index
    redirect_to '/tendencies'
  end

  def new
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
      redirect_to '/dashboard'
    else
      render :new
    end

  end

  def show
  end

end
