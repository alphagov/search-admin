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

ActiveRecord::Schema.define(version: 20151016132421) do

  create_table "bets", force: :cascade do |t|
    t.string  "link",     limit: 255
    t.integer "position", limit: 4,     default: 1
    t.text    "comment",  limit: 65535
    t.integer "user_id",  limit: 4
    t.boolean "manual",                 default: false
    t.integer "query_id", limit: 4
    t.boolean "is_best",                default: true
  end

  create_table "queries", force: :cascade do |t|
    t.string   "query",      limit: 255
    t.string   "match_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string  "name",                limit: 255
    t.string  "email",               limit: 255
    t.string  "uid",                 limit: 255
    t.string  "organisation_slug",   limit: 255
    t.string  "permissions",         limit: 255
    t.boolean "remotely_signed_out",             default: false
  end

end
