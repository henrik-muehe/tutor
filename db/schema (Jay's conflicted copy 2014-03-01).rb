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

ActiveRecord::Schema.define(version: 20140226105122) do

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

  create_table "chat_messages", force: true do |t|
    t.string   "room"
    t.string   "type"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chat_messages", ["room"], name: "index_chat_messages_on_room"

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "startweek"
  end

  create_table "courses_users", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses_users", ["course_id"], name: "index_courses_users_on_course_id"
  add_index "courses_users", ["user_id"], name: "index_courses_users_on_user_id"

  create_table "exam_assessments", force: true do |t|
    t.integer  "exam_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "exam_assessments", ["exam_id"], name: "index_exam_assessments_on_exam_id"
  add_index "exam_assessments", ["student_id"], name: "index_exam_assessments_on_student_id"

  create_table "exam_seats", force: true do |t|
    t.integer  "exam_id"
    t.integer  "student_id"
    t.integer  "room_id"
    t.string   "seat_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exam_seats", ["exam_id"], name: "index_exam_seats_on_exam_id"
  add_index "exam_seats", ["room_id"], name: "index_exam_seats_on_room_id"
  add_index "exam_seats", ["student_id"], name: "index_exam_seats_on_student_id"

  create_table "exam_task_assessments", force: true do |t|
    t.integer  "exam_task_id"
    t.decimal  "points",             precision: 4, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exam_assessment_id"
  end

  add_index "exam_task_assessments", ["exam_assessment_id"], name: "index_exam_task_assessments_on_exam_assessment_id"
  add_index "exam_task_assessments", ["exam_task_id"], name: "index_exam_task_assessments_on_exam_task_id"

  create_table "exam_tasks", force: true do |t|
    t.integer  "exam_id"
    t.integer  "number"
    t.string   "name"
    t.integer  "max_points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exam_tasks", ["exam_id"], name: "index_exam_tasks_on_exam_id"

  create_table "exams", force: true do |t|
    t.string   "name"
    t.datetime "start"
    t.text     "original_import"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "seat_assignment"
    t.string   "magictoken"
    t.integer  "course_id"
  end

  add_index "exams", ["course_id"], name: "index_exams_on_course_id"

  create_table "exams_rooms", force: true do |t|
    t.integer  "exam_id"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exams_rooms", ["exam_id"], name: "index_exams_rooms_on_exam_id"
  add_index "exams_rooms", ["room_id"], name: "index_exams_rooms_on_room_id"

  create_table "exams_students", force: true do |t|
    t.integer "exam_id"
    t.integer "student_id"
  end

  add_index "exams_students", ["exam_id"], name: "index_exams_students_on_exam_id"
  add_index "exams_students", ["student_id"], name: "index_exams_students_on_student_id"

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

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.text     "seats"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "magictoken"
    t.string   "role"
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
