class StatsController < ApplicationController

  def index
    @title = "ProScout - Stats Dashboard"
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

      # Finding past reviewed games and practice session
      @previous_games = Game.where("needs_review = ? AND user_id = ?", false, @user.id).limit(3)
      @previous_practices = PracticeSession.where("needs_review = ? AND user_id = ?", false, @user.id).limit(3)

      # Stats for averages
      @stats = Stat.where("user_id = ?", @user.id)

      # Initial queries for stats chart
      @sort_by = 'points'
      @first_query = Game.joins(:stat).where(stats: { user_id: @user.id })
      @chart_query = @first_query.group(:date).average(:points)

      if params[:sort_by]
        @sort_by = params[:sort_by]
        @chart_query = @first_query.group(:date).average(@sort_by)

        # Track chart sort by stat
        woopra = WoopraTracker.new(request)
        woopra_configure

        woopra.track("stats_chart_changed", {
          stat: @sort_by
        }, true)
      end

      @averages = {}
      @stats.each do |stat|
        if stat.game_started
          @averages["gs"] = @averages["gs"].to_i + 1
        end
        @averages["mins"] = @averages["mins"].to_i + stat.minutes
        @averages["fgm"] = @averages["fgm"].to_f + stat.fgm
        @averages["fga"] = @averages["fga"].to_f + stat.fga
        @averages["fgp"] = @averages["fgp"].to_i + stat.fgp
        @averages["threepm"] = @averages["threepm"].to_f + stat.threepm
        @averages["threepa"] = @averages["threepa"].to_f + stat.threepa
        @averages["threepp"] = @averages["threepp"].to_i + stat.threepp
        @averages["ftm"] = @averages["ftm"].to_f + stat.ftm
        @averages["fta"] = @averages["fta"].to_f + stat.fta
        @averages["ftp"] = @averages["ftp"].to_i + stat.ftp
        @averages["orb"] = @averages["orb"].to_f + stat.offensive_reb
        @averages["drb"] = @averages["drb"].to_f + stat.defensive_reb
        @averages["trb"] = @averages["trb"].to_i + stat.total_reb
        @averages["ast"] = @averages["ast"].to_f + stat.assists
        @averages["stl"] = @averages["stl"].to_f + stat.steals
        @averages["blk"] = @averages["blk"].to_f + stat.block
        @averages["to"] = @averages["to"].to_f + stat.turnovers
        @averages["pfs"] = @averages["pfs"].to_f + stat.pfs
        @averages["pts"] = @averages["pts"].to_f + stat.points
      end

      if !@averages.empty?
        @averages["mins"] = @averages["mins"]/@stats.count
        @averages["fgm"] = (@averages["fgm"]/@stats.count).round(1)
        @averages["fga"] = (@averages["fga"]/@stats.count).round(1)
        @averages["fgp"] = @averages["fgp"]/@stats.count
        @averages["threepm"] = (@averages["threepm"]/@stats.count).round(1)
        @averages["threepa"] = (@averages["threepa"]/@stats.count).round(1)
        @averages["threepp"] = @averages["threepp"]/@stats.count
        @averages["ftm"] = (@averages["ftm"]/@stats.count).round(1)
        @averages["fta"] = (@averages["fta"]/@stats.count).round(1)
        @averages["ftp"] = (@averages["ftp"]/@stats.count).round(1)
        @averages["orb"] = (@averages["orb"]/@stats.count).round(1)
        @averages["drb"] = (@averages["drb"]/@stats.count).round(1)
        @averages["trb"] = (@averages["trb"]/@stats.count).round(1)
        @averages["ast"] = (@averages["ast"]/@stats.count).round(1)
        @averages["stl"] = (@averages["stl"]/@stats.count).round(1)
        @averages["blk"] = (@averages["blk"]/@stats.count).round(1)
        @averages["to"] = (@averages["to"]/@stats.count).round(1)
        @averages["pfs"] = (@averages["pfs"]/@stats.count).round(1)
        @averages["pts"] = (@averages["pts"]/@stats.count).round(1)
      end

    end
  end

  def create

    game = Game.find_by(id: params[:game_id])
    user = User.find_by(id: params[:user_id])

    # update user information
    user.game_id = game.id

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

    if user.save

      if stats.save
        game.stat_id = stats.id
        game.needs_review = false

        if game.save

          # Tracking when admin review is completed
          woopra = WoopraTracker.new(request)
          woopra_configure

          woopra.track("review_completed", {
            review_type: "game"
          }, true)

          redirect_to '/admin/complete-game-review/confirmed'
        end

      else
        redirect_to "/admin/game/#{game.id}/show/admin-review"
      end
    end
  end

end
