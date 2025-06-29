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

ActiveRecord::Schema[8.0].define(version: 2025_06_18_135003) do
  create_table "completion_denylist_entries", charset: "utf8mb3", force: :cascade do |t|
    t.string "phrase", null: false
    t.integer "match_type", default: 0, null: false
    t.integer "category", default: 0, null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_completion_denylist_entries_on_category"
    t.index ["phrase"], name: "index_completion_denylist_entries_on_phrase", unique: true
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
