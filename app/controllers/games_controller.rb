class GamesController < ApplicationController

  def index
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def confirmation
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def show
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def new
    redirect_to_route_if_not_logged_in(route = 'login')

    @game = Game.new
  end

  def create

    # create new game review
    @game = Game.new
    @game.user_id = current_user.id
    @game.title = params[:game_title]
    @game.date = params[:game_date]
    @game.team_name = params[:team_name]
    @game.opponent_name = params[:opponent_name]
    @game.team_score = params[:team_score]
    @game.opponent_score = params[:opponent_score]
    @game.player_number = params[:player_number]
    @game.needs_review = true

    # checking if youtube or file upload
    if params[:video_file] != ""
      @game.game_url = params[:video_file]
    else
      @game.game_url = params[:video_url]
    end

    if @game.save
      redirect_to '/game/confirmation'
    else
      render :new
    end

  end

end
