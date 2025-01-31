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

ActiveRecord::Schema[8.0].define(version: 2025_01_28_074343) do
  create_table "control_boost_actions", charset: "utf8mb3", force: :cascade do |t|
    t.string "filter_expression", null: false
    t.float "boost_factor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "(`boost_factor` between -(1.0) and 1.0) and (`boost_factor` <> 0)", name: "valid_boost_factor"
  end

  create_table "control_filter_actions", charset: "utf8mb3", force: :cascade do |t|
    t.string "filter_expression", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "controls", charset: "utf8mb3", force: :cascade do |t|
    t.string "action_type", null: false
    t.integer "action_id", null: false
    t.string "display_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_type", "action_id"], name: "index_controls_on_action_type_and_action_id", unique: true
  end

  create_table "recommended_links", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.text "description"
    t.text "keywords"
    t.text "comment"
    t.integer "user_id"
    t.string "content_id", limit: 36
    t.index ["content_id"], name: "index_recommended_links_on_content_id", unique: true
    t.index ["link"], name: "index_recommended_links_on_link", unique: true
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "uid"
    t.string "organisation_slug"
    t.string "permissions"
    t.boolean "remotely_signed_out", default: false
    t.boolean "disabled", default: false
    t.string "organisation_content_id"
  end
end
