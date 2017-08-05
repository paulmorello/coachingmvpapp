class GamesController < ApplicationController

  def index
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

      # Finding past reviewed games
      @previous_games = Game.where("needs_review = ? AND user_id = ?", false, @user.id).limit(10)
    end
  end

  def game_view
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

      @game = Game.find_by(id: params[:id])
      @stats = Stat.find_by(game_id: @game.id)

    end
  end

  def confirmation
    redirect_to_route_if_not_logged_in(route = 'login')

  end

  def show
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "/dashboard/#{current_user.username}")
    end

    @game = Game.find_by(id: params[:id])
    @user = User.find_by(id: @game.user_id)

    if @game.user_id != @user.id
      redirect_to "/dashboard/#{current_user.username}"
    end

    # Finding past reviewed games
    @previous_games = Game.where("needs_review = ? AND user_id = ?", false, @user.id)

  end

  def admin_review
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "/dashboard/#{current_user.username}")
    end

    @game = Game.find_by(id: params[:id])
    @user = User.find_by(id: @game.user_id)

    if @game.team_score > @game.opponent_score
      @win_loss = 'Win'
    else
      @win_loss = 'Loss'
    end
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

  def confirm_complete_review
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

  end

end
