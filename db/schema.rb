# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_28_171904) do

  create_table "bets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "link"
    t.integer "position", default: 1
    t.text "comment"
    t.boolean "manual", default: false
    t.integer "query_id"
    t.boolean "is_best", default: true
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "expiration_date"
    t.boolean "permanent", default: false
  end

  create_table "queries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "query"
    t.string "match_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommended_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.text "description"
    t.text "keywords"
    t.text "comment"
    t.integer "user_id"
    t.string "content_id", limit: 36
    t.index ["content_id"], name: "index_recommended_links_on_content_id", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
