# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_08_020127) do

  create_table "actors", force: :cascade do |t|
    t.string "name"
    t.integer "dialogues_count"
  end

  create_table "alternates", force: :cascade do |t|
    t.string "alternateline"
    t.string "conditionstring"
    t.integer "dialogue_id"
  end

  create_table "checks", force: :cascade do |t|
    t.string "isred"
    t.string "difficulty"
    t.string "flagname"
    t.string "skilltype"
    t.integer "dialogue_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "dialogues_count"
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
    t.integer "origins_count"
    t.integer "destinations_count"
    t.integer "alternates_count"
    t.integer "checks_count"
    t.integer "lineage"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string "variable"
    t.string "modification"
    t.string "tooltip"
    t.integer "dialogue_id"
  end

  create_table "tfc_transforms", force: :cascade do |t|
    t.integer "dialogue_id", null: false
    t.index ["dialogue_id"], name: "index_tfc_transforms_on_dialogue_id"
  end

  add_foreign_key "alternates", "dialogues"
  add_foreign_key "checks", "dialogues"
  add_foreign_key "modifiers", "dialogues"
  add_foreign_key "tfc_transforms", "dialogues"
end
