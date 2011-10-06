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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111006131814) do

  create_table "answer_conflicts", :force => true do |t|
    t.integer "answer_id"
    t.integer "other_answer_id"
  end

  add_index "answer_conflicts", ["answer_id"], :name => "index_answer_conflicts_on_answer_id"
  add_index "answer_conflicts", ["other_answer_id"], :name => "index_answer_conflicts_on_other_answer_id"

  create_table "answers", :force => true do |t|
    t.text     "answer"
    t.integer  "ordering"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "answers", ["ordering"], :name => "index_answers_on_ordering"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "dashboard_items", :force => true do |t|
    t.string   "gquery"
    t.string   "label"
    t.string   "steps"
    t.integer  "ordering"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dashboard_items", ["ordering"], :name => "index_dashboard_items_on_ordering"

  create_table "inputs", :force => true do |t|
    t.decimal  "value",      :precision => 10, :scale => 2
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "slider_id"
  end

  add_index "inputs", ["answer_id"], :name => "index_inputs_on_answer_id"

  create_table "popups", :force => true do |t|
    t.string   "code"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "popups", ["code"], :name => "index_popups_on_code"

  create_table "question_sets", :force => true do |t|
    t.string   "name"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "end_year"
  end

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.integer  "ordering"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "information"
    t.integer  "question_set_id"
  end

  add_index "questions", ["ordering"], :name => "index_questions_on_ordering"

  create_table "scenario_answers", :force => true do |t|
    t.integer  "scenario_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score"
  end

  add_index "scenario_answers", ["question_id"], :name => "index_user_scenario_answers_on_question_id"
  add_index "scenario_answers", ["scenario_id"], :name => "index_user_scenario_answers_on_user_scenario_id"

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "age"
    t.boolean  "featured",        :default => false, :null => false
    t.float    "output_0"
    t.float    "output_1"
    t.float    "output_2"
    t.float    "output_3"
    t.float    "output_4"
    t.float    "output_5"
    t.float    "output_6"
    t.float    "output_7"
    t.float    "output_8"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "etm_scenario_id"
    t.float    "output_9"
    t.float    "output_10"
    t.float    "output_11"
    t.boolean  "public",          :default => true
    t.float    "output_12"
    t.float    "score"
    t.boolean  "average",         :default => false
    t.integer  "year"
  end

  add_index "scenarios", ["average"], :name => "index_scenarios_on_average"
  add_index "scenarios", ["featured"], :name => "index_user_scenarios_on_featured"
  add_index "scenarios", ["public"], :name => "index_scenarios_on_public"
  add_index "scenarios", ["score"], :name => "index_scenarios_on_score"

  create_table "translations", :force => true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["locale", "key"], :name => "index_translations_on_locale_and_key"

  create_table "users", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.string   "password_salt",                     :default => "", :null => false
    t.integer  "sign_in_count",                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                   :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
