class UsersController < ApplicationController

  def home
    @title = "ProScout - Your Personal Scouting Profile"
  end

  def dashboard
    @title = "ProScout - Dashboard"
    redirect_to_route_if_not_logged_in(route = 'login')

    # check if user is logged in again
    @user = current_user

    if @user != nil
      not_allowed_access?

      # Finding past reviewed games and practice session
      @previous_games = Game.where("needs_review = ? AND user_id = ?", false, @user.id).limit(3)
      @previous_practices = PracticeSession.where("needs_review = ? AND user_id = ?", false, @user.id).limit(3)

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

  def new
    @title = "ProScout - Sign Up"
    if logged_in?
      redirect_to_route_if_logged_in(route = "dashboard/#{current_user.username}")
    end

    # new user instance for errors
    @user = User.new
  end

  def trial_signup
    @title = "ProScout - Trial Sign Up Form"
    if logged_in? && current_user.subscription != 'demo'
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
    @user.avatar = 'default-avatar.svg'
    @user.admin = false
    @user.next_billing_date = Time.now + 1.month

    # check if user has signed up for a trial or pro subscription
    if params[:subscription] == 'trial'
      @user.subscription = 'trial'
      @user.video_reviews = 2
    else
      @user.subscription = 'pro'
      @user.video_reviews = 4
    end

    if @user.save
      session[:user_id] = @user.id

      # Tracking new signups
      woopra = WoopraTracker.new(request)
      woopra_configure

      # Woopra identify visitor logging in
      woopra.identify({
        email: @user.email,
        name: @user.first_name + ' ' + @user.last_name,
        username: @user.username,
        first_name: @user.first_name,
        last_name: @user.last_name,
        team_name: @user.team_name,
        avatar: @user.avatar,
        subscription: @user.subscription
      })

      # Track signup form
      woopra.track("signup", {
        username: @user.username,
        email: @user.email,
        team_name: @user.team_name,
        subscription: @user.subscription
      }, true)

      if params[:subscription] == 'trial'
        sleep 3
          redirect_to '/confirmation/trial-confirmed'
      else
        sleep 3
          redirect_to '/confirmation/payment-confirmed'
      end
    else

      render :trial_signup
    end

  end

  def show
    @title = "ProScout - User Profile"
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def edit
    @title = "ProScout - Edit User Profile"
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
    @user.new_avatar = params[:new_avatar]

    # Check if username field is empty
    if params[:password] != ''
      @user.password = params[:password]
    end

    if @user.save

      # Track users updating their account
      woopra = WoopraTracker.new(request)
      woopra_configure

      # Woopra identify visitor updating account
      woopra.identify({
        email: @user.email,
        name: @user.first_name + ' ' + @user.last_name,
        username: @user.username,
        first_name: @user.first_name,
        last_name: @user.last_name,
        avatar: @user.avatar
      })

      # Track update account details
      woopra.track("update_account", {
        username: @user.username,
        email: @user.email,
        first_name: @user.first_name,
        last_name: @user.last_name,
        team_name: @user.team_name
      }, true)

      @success = "You have successfully updated your account."
      return redirect_to user_path
    end
    render :edit
  end

  def update_payment
    @title = "ProScout - Update Payment"
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def confirm_payment
    @title = "ProScout - Payment Confirmed"
  end

  def confirm_trial
    @title = "ProScout - Trial Confirmed"
  end

  def cancel_account
    @title = "ProScout - Cancel Account"
    redirect_to_route_if_not_logged_in(route = 'login')
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def delete_account
    @title = "ProScout - Delete Account"
    @user = current_user

    if @user != nil
      not_allowed_access?

    end
  end

  def destroy

    user = current_user

    if user && user.username == params[:username]

      # Track user deleting account
      woopra = WoopraTracker.new(request)
      woopra_configure

      woopra.track("deleted_account", {
        username: user.username,
        team_name: user.team_name,
        email: user.email
      }, true)

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
    @title = "ProScout - Admin Dashboard"
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    if params[:user_search]
      user = params[:user_search].downcase
      @search_user = User.find_by(email: user)
      @search_game_count = Game.where("needs_review = ? AND user_id = ?", true, @search_user.id).count
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
    @title = "ProScout - All Game Reviews"
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    offset = 0
    @games = Game.where(needs_review: true).limit(25).offset(offset)
  end

  def practice_reviews
    @title = "ProScout - All Practice Reviews"
    redirect_to_route_if_not_logged_in(route = 'login')
    if logged_in?
      is_not_admin?(route = "dashboard/#{current_user.username}")
    end

    offset = 0
    @practice = PracticeSession.where(needs_review: true).limit(25).offset(offset)
  end

end
