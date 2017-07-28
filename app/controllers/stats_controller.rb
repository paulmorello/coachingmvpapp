class StatsController < ApplicationController

  def index
    redirect_to_route_if_not_logged_in(route = 'login')
    is_not_admin?(route = 'dashboard')

  end

  def create

    game = Game.find_by(id: params[:game_id])
    user = User.find_by(id: params[:user_id])

    # create stats for game review
    stats = Stat.new
    stats.game_id =  params[:game_id]
    stats.user_id = params[:user_id]

    # Did user start the game
    if params[:gs].downcase == 'y'
      stats.game_started = true
    else
      stats.game_started = false
    end

    stats.minutes =  params[:mins].to_i
    stats.fgm = params[:fgm].to_i
    stats.fga = params[:fga].to_i
    stats.fgp = (params[:fgm].to_f/params[:fga].to_f).round(4)*100
    stats.threepm = params[:tpm].to_i
    stats.threepa = params[:tpa].to_i
    stats.threepp = (params[:tpm].to_f/params[:tpa].to_f).round(4)*100
    stats.ftm = params[:ftm].to_i
    stats.fta = params[:fta].to_i
    stats.ftp = (params[:ftm].to_f/params[:fta].to_f).round(4)*100
    stats.offensive_reb = params[:orb].to_i
    stats.defensive_reb = params[:drb].to_i
    stats.total_reb = (params[:orb].to_i+params[:drb].to_i)
    stats.assists = params[:assists].to_i
    stats.steals = params[:steals].to_i
    stats.block = params[:blocks].to_i
    stats.turnovers = params[:tos].to_i
    stats.pfs = params[:pfs].to_i
    stats.points = params[:pts].to_i
    stats.game_notes = params[:game_notes]
    stats.player_tendencies = params[:player_tendencies]

    if stats.save
      game.stat_id = stats.id
      game.needs_review = false

      if game.save
        redirect_to '/admin'
      end
      
    else
      redirect_to "/admin/game/#{game.id}/show/admin-review"
    end

  end

end
