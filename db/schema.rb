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

ActiveRecord::Schema.define(version: 20210324033936) do

  create_table "actors", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "dialogue_links", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.integer "priority"
  end

  create_table "dialogues", force: :cascade do |t|
    t.integer  "conversation_id"
    t.text     "dialoguetext"
    t.integer  "incid"
    t.integer  "actor_id"
    t.string   "title"
    t.integer  "difficultypass"
    t.text     "sequence"
    t.text     "conditionstring"
    t.text     "userscript"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "dialogues", ["conversation_id"], name: "index_dialogues_on_conversation_id"

end