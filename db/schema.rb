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

ActiveRecord::Schema.define(version: 20160204185020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cabpool_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cabpools", force: :cascade do |t|
    t.integer  "number_of_people"
    t.time     "timein"
    t.time     "timeout"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "route"
    t.integer  "cabpool_type_id"
    t.string   "remarks"
  end

  add_index "cabpools", ["cabpool_type_id"], name: "index_cabpools_on_cabpool_type_id", using: :btree

  create_table "cabpools_localities", force: :cascade do |t|
    t.integer "cabpool_id"
    t.integer "locality_id"
  end

  add_index "cabpools_localities", ["cabpool_id"], name: "index_cabpools_localities_on_cabpool_id", using: :btree
  add_index "cabpools_localities", ["locality_id"], name: "index_cabpools_localities_on_locality_id", using: :btree

  create_table "localities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cabpool_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "approve_digest"
  end

  add_index "requests", ["cabpool_id"], name: "index_requests_on_cabpool_id", using: :btree
  add_index "requests", ["user_id"], name: "index_requests_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
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
    t.string   "status"
    t.string   "phone_no"
    t.integer  "role_id"
  end

  add_index "users", ["cabpool_id"], name: "index_users_on_cabpool_id", using: :btree
  add_index "users", ["locality_id"], name: "index_users_on_locality_id", using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  add_foreign_key "cabpools", "cabpool_types"
  add_foreign_key "cabpools_localities", "cabpools"
  add_foreign_key "cabpools_localities", "localities"
  add_foreign_key "requests", "cabpools"
  add_foreign_key "requests", "users"
  add_foreign_key "users", "cabpools"
  add_foreign_key "users", "localities"
  add_foreign_key "users", "roles"
end
