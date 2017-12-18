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

ActiveRecord::Schema.define(version: 20171214153332) do

  create_table "bets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "link"
    t.integer "position",               default: 1
    t.text    "comment",  limit: 65535
    t.boolean "manual",                 default: false
    t.integer "query_id"
    t.boolean "is_best",                default: true
    t.integer "user_id"
  end

  create_table "queries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "query"
    t.string   "match_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommended_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "title"
    t.string  "link"
    t.text    "description", limit: 65535
    t.text    "keywords",    limit: 65535
    t.text    "comment",     limit: 65535
    t.integer "user_id"
    t.string  "content_id",  limit: 36
    t.index ["content_id"], name: "index_recommended_links_on_content_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.string  "email"
    t.string  "uid"
    t.string  "organisation_slug"
    t.string  "permissions"
    t.boolean "remotely_signed_out",     default: false
    t.boolean "disabled",                default: false
    t.string  "organisation_content_id"
  end

end
