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

ActiveRecord::Schema.define(:version => 20110311072305) do

  create_table "answers", :force => true do |t|
    t.string   "answer"
    t.integer  "ordering"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "answers", ["ordering"], :name => "index_answers_on_ordering"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "input_elements", :force => true do |t|
    t.string "key"
  end

  add_index "input_elements", ["key"], :name => "index_input_elements_on_key", :unique => true

  create_table "inputs", :force => true do |t|
    t.string   "key"
    t.decimal  "value",      :precision => 10, :scale => 2
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "slider_id"
  end

  add_index "inputs", ["answer_id"], :name => "index_inputs_on_answer_id"

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.integer  "ordering"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "information"
  end

  add_index "questions", ["ordering"], :name => "index_questions_on_ordering"

  create_table "results", :force => true do |t|
    t.string   "gquery"
    t.string   "key"
    t.string   "description"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
