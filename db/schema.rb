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

ActiveRecord::Schema.define(version: 20151201095812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cabpools", force: :cascade do |t|
    t.string   "route"
    t.integer  "number_of_people"
    t.integer  "locality_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.time     "timein"
    t.time     "timeout"
  end

  add_index "cabpools", ["locality_id"], name: "index_cabpools_on_locality_id", using: :btree

  create_table "localities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "emp_id"
    t.string   "name"
    t.string   "email"
    t.text     "address"
    t.integer  "locality_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "cabpool_id"
  end

  add_index "users", ["locality_id"], name: "index_users_on_locality_id", using: :btree

  add_foreign_key "cabpools", "localities"
  add_foreign_key "users", "localities"
end
