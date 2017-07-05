# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170705033818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drills", force: :cascade do |t|
    t.text "drill_url"
    t.text "title"
    t.text "category"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.text "title"
    t.date "date"
    t.text "game_url"
    t.text "team_name"
    t.text "opponent_name"
    t.integer "user_id"
    t.integer "team_score"
    t.integer "opponent_score"
    t.integer "stat_id"
    t.integer "game_number"
    t.integer "player_number"
    t.boolean "needs_review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "practice_sessions", force: :cascade do |t|
    t.text "pratice_notes"
    t.integer "user_id"
    t.date "date"
    t.text "practice_session_url"
    t.text "focus"
    t.text "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stats", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.boolean "game_started"
    t.integer "minutes"
    t.integer "fgm"
    t.integer "fga"
    t.integer "fgp"
    t.integer "threepm"
    t.integer "threepa"
    t.integer "threepp"
    t.integer "ftm"
    t.integer "fta"
    t.integer "ftp"
    t.integer "offensive_reb"
    t.integer "defensive_reb"
    t.integer "total_reb"
    t.integer "assists"
    t.integer "steals"
    t.integer "block"
    t.integer "turnovers"
    t.integer "pfs"
    t.integer "points"
    t.integer "plus_minus"
    t.integer "min_on"
    t.integer "min_off"
    t.integer "plus_minus_on"
    t.integer "plus_minus_off"
    t.text "player_lineup_numbers"
    t.integer "lineup_plus_minus"
    t.text "game_notes"
    t.text "player_tendencies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "email"
    t.text "first_name"
    t.text "last_name"
    t.text "password_digest"
    t.text "avatar"
    t.text "username"
    t.integer "game_id"
    t.boolean "admin"
    t.text "subscription"
    t.integer "practice_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_name"
  end

  create_table "videos", force: :cascade do |t|
    t.text "title"
    t.date "game_date"
    t.text "video_url"
    t.integer "practice_session_id"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
