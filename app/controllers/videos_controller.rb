class VideosController < ApplicationController

  def new

  end

  def create

    video = Video.new
    video.user_id = current_user.id
    video.title = params[:title]
    video.game_date = params[:game_date]

    # check if user uploads video from local storage or youtube
    if params[:video_file] != ""
      video.video_url = params[:video_file]
    else
      video.video_url = params[:video_url]
    end

    # Check if user uploads practice session or game review
    if params[:upload_type] == 'practice_session'

      # If user selects practice session, create a new practice session
      practice_session = PracticeSession.new
      practice_session.user_id = current_user.id
      practice_session.date = params[:game_date]

      if params[:video_file] != ""
        practice_session.practice_session_url = params[:video_file]
      else
        practice_session.practice_session_url = params[:video_url]
      end

      if practice_session.save!
        video.practice_session_id = practice_session.id
      else
        redirect_to 'videos/new'
      end

    elsif params[:upload_type] == 'game_review'

      # create new game review
      game = Game.new
      game.user_id = current_user.id
      game.title = params[:title]
      game.date = params[:game_date]

      if params[:video_file] != ""
        game.game_url = params[:video_file]
      else
        game.game_url = params[:video_url]
      end

      game.team_name = params[:team_name]
      game.opponent_name = params[:opponent_name]
      game.team_score = params[:team_score]
      game.opponent_score = params[:opponent_score]
      game.player_number = params[:player_number]
      game.needs_review = true

      if game.save!
        video.game_id = game.id
      else
        redirect_to 'videos/new'
      end
    end

    @errors = {}
    # check to make sure a practice sesion is chosen
    if params[:upload_type] != 'practice_session' || params[:upload_type] != 'game_review'

      # check for form errors
      video.errors.messages.each do |key, value|
        if value.any?
          @errors[key] = '*' + value.join(', ')
        end
      end

      redirect_to '/videos/new'
    else

      if video.save!
        redirect_to '/dashboard'
      else

        video.errors.messages.each do |key, value|
          if value.any?
            @errors[key] = '*' + value.join(', ')
          end
        end

        redirect_to '/videos/new'
      end
    end

  end

end
