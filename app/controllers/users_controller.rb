class UsersController < ApplicationController

  def home

  end

  def dashboard
    redirect_to_route_if_not_logged_in(route = 'login')

    # check if user is logged in again
    @user = current_user

    if @user != nil
      not_allowed_access?

      # Finding past reviewed games
      @previous_games = Game.where("needs_review = ? AND user_id = ?", false, @user.id).limit(3)

      # Stats for averages
      @stats = Stat.where("user_id = ?", @user.id)

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

  def new
    if logged_in?
      redirect_to_route_if_logged_in(route = "dashboard/#{current_user.username}")
    end

    # new user instance for errors
    @user = User.new
  end

  def create

    @user = User.new
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.team_name = params[:team_name]
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.avatar = "/assets/avatar.svg"
    @user.admin = false
    @user.subscription = 'trial'

    if @user.save
      session[:user_id] = @user.id

      sleep 3
        redirect_to '/confirmation/payment-confirmed'
    else

      render :new
    end

  end

  def show
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def edit
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def update

    @user = current_user
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.username = params[:username_new]
    @user.email = params[:email]

    # Check if username field is empty
    if params[:password] != ''
      @user.password = params[:password]
    end

    if @user.save
      @success = "You have successfully updated your account."
      return redirect_to user_path
    end
    render :edit
  end

  def update_payment
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def confirm_payment
  end

  def cancel_account
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def delete_account
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def destroy

    user = current_user

    if user && user.username == params[:username]
      user.delete
      sleep 3
        redirect_to "/confirmation/delete-account"
    else
      sleep 3
        redirect_to "/users/#{current_user.username}"
    end
  end

  # Admin pages for game and page reviews
  def admin
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    @games = Game.where(needs_review: true).limit(10)
    @game_total = @games.count

    @practice = PracticeSession.where(needs_review: true).limit(10)
    @practice_total = @practice.count
  end

  def admin_access

    user = User.find_by(email: params[:admin_email])

    # check if user is admin, if not make admin
    if !user.admin

      user.admin = true

      if user.save
        redirect_to '/admin'
      end
    else

      user.admin = false

      if user.save
        redirect_to '/admin'
      end
      redirect_to '/admin'
    end
  end

  def game_reviews
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    offset = 0
    @games = Game.where(needs_review: true).limit(25).offset(offset)
  end

  def practice_reviews
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    offset = 0
    @practice = PracticeSession.where(needs_review: true).limit(25).offset(offset)
  end

end
