# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131104114958) do

  create_table "analyses", force: true do |t|
    t.string   "name"
    t.text     "query"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "view"
  end

  create_table "assessments", force: true do |t|
    t.integer  "student_id"
    t.integer  "user_id"
    t.integer  "value"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "week_id"
    t.integer  "group_id"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "startweek"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "start"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "room"
  end

  create_table "groups_students", force: true do |t|
    t.integer "group_id"
    t.integer "student_id"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "students", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.integer  "matrnr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "students", ["token"], name: "index_students_on_token", unique: true

  create_table "users", force: true do |t|
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "firstname"
    t.string   "lastname"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "weeks", force: true do |t|
    t.datetime "start"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
  end

end
