class PracticeSessionsController < ApplicationController

  def tendencies
    @title = "ProScout - Practice Session Dashboard"
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?


      # Finding past reviewed games
      @previous_practices = PracticeSession.where("needs_review = ? AND user_id = ?", false, @user.id)
    end
  end

  def practice_view
    @title = "ProScout - Practice Overview"
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

      @practice = PracticeSession.find_by(user_id: @user.id)

      # Track User viewing practice notes
      woopra = WoopraTracker.new(request)
      woopra_configure

      woopra.track("practice_review", {
        practice_title: @practice.title,
        practice_date: @practice.date,
        player_focus: @practice.focus,
        team_name: @user.team_name
      }, true)
    end
  end

  def confirmation
    @title = "ProScout - Practice Session Upload Confirmation"
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def index
    @title = "ProScout - Practice session Dashboard"
    redirect_to_route_if_not_logged_in(route = 'login')
    redirect_to '/tendencies'

  end

  def new
    @title = "ProScout - New Practice Session Upload"
    redirect_to_route_if_not_logged_in(route = 'login')

    # creating instance of practice session for errors
    @practice = PracticeSession.new
  end

  def create

    # check if user has reviews available
    @user = current_user
    if @user.video_reviews == 0
      @error = 'You have no more reviews available'

      redirect_to '/practice_session/new'
    else
      # reduce number of video reviews
      @user.video_reviews -= 1
    end

    # Create a new practice session
    @practice = PracticeSession.new
    @practice.user_id = current_user.id
    @practice.title = params[:practice_title]
    @practice.date = params[:practice_date]
    @practice.practice_session_url = params[:video_url]
    @practice.needs_review = true

    # Allow for larger video uploads in the future but
    # for now files would be too big to upload and cost too much to store

    # if params[:video_file] != ""
    #   @practice.practice_session_url = params[:video_file]
    # end

    if @practice.save
      if @user.save

        # Tracking new practice session upload
        woopra = WoopraTracker.new(request)
        woopra_configure

        woopra.track("practice_session_uploaded", {
          username: @user.username,
          team_name: @user.team_name,
          subscription: @user.subscription,
          title: @practice.title,
          practice_date: @practice.date,
          practice_url: @practice.practice_session_url
        }, true)

        redirect_to '/practice/confirmation'
      end
    else
      render :new
    end

  end

  def show
    @title = "ProScout - Practice Admin Review"
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    @practice = PracticeSession.find_by(id: params[:id])
    @user = User.find_by(id: @practice.user_id)

    # Finding past reviewed games
    @previous_practices = PracticeSession.where("needs_review = ? AND user_id = ?", false, @user.id)

  end

  def admin_review
    @title = "ProScout - Practice Final Admin Review"
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    @practice = PracticeSession.find_by(id: params[:id])
    @user = User.find_by(id: @practice.user_id)

  end

  def complete_review
    @title = "ProScout - Practice Complete Review"
    # Updating user and Practice session properties
    @practice = PracticeSession.find_by(id: params[:practice_id])
    @user = User.find_by(id: params[:user_id])

    # update practice session id
    @user.practice_session_id = @practice.id

    # Update practice properties
    @practice.focus = params[:focus]
    @practice.practice_notes = params[:practice_notes]
    @practice.additional_notes = params[:additional_notes]

    if @user.save
      @practice.needs_review = false
      if @practice.save

        # Tracking when admin review is completed
        woopra = WoopraTracker.new(request)
        woopra_configure

        woopra.track("review_completed", {
          review_type: "practice"
        }, true)

        redirect_to '/admin/complete-practice-review/confirmed'
      else
        redirect_to "/admin/practice/#{@practice.id}/show/admin-review"
      end
    end
  end

  def confirm_complete_review
    @title = "ProScout - Practice Admin Review Completed"
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

  end

end
