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

ActiveRecord::Schema.define(version: 2021_04_26_122500) do

  create_table "actors", force: :cascade do |t|
    t.string "name"
  end

  create_table "alternates", force: :cascade do |t|
    t.string "alternateline"
    t.string "conditionstring"
    t.integer "dialogue_id"
    t.index ["dialogue_id"], name: "index_alternates_on_dialogue_id"
  end

  create_table "checks", force: :cascade do |t|
    t.string "isred"
    t.string "difficulty"
    t.string "flagname"
    t.string "skilltype"
    t.integer "dialogue_id"
    t.index ["dialogue_id"], name: "index_checks_on_dialogue_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.string "title"
    t.text "description"
  end

  create_table "dialogue_links", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.integer "priority"
  end

  create_table "dialogues", force: :cascade do |t|
    t.integer "conversation_id"
    t.text "dialoguetext"
    t.integer "incid"
    t.integer "actor_id"
    t.string "title"
    t.integer "difficultypass"
    t.text "sequence"
    t.text "conditionstring"
    t.text "userscript"
    t.index ["actor_id"], name: "index_dialogues_on_actor_id"
    t.index ["conversation_id"], name: "index_dialogues_on_conversation_id"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string "variable"
    t.string "modification"
    t.string "tooltip"
    t.integer "dialogue_id"
    t.index ["dialogue_id"], name: "index_modifiers_on_dialogue_id"
  end

end
