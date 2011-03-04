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

ActiveRecord::Schema.define(:version => 20110304091407) do

  create_table "answers", :force => true do |t|
    t.string   "answer"
    t.integer  "order"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inputs", :force => true do |t|
    t.string   "key"
    t.decimal  "value",      :precision => 10, :scale => 2
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inputs", ["answer_id"], :name => "index_inputs_on_answer_id"

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
