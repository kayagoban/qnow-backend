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

ActiveRecord::Schema.define(version: 2020_04_07_154313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "known_merchant_users", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "merchant_id", null: false
    t.integer "position"
    t.index ["client_id"], name: "index_known_merchant_users_on_client_id"
    t.index ["merchant_id"], name: "index_known_merchant_users_on_merchant_id"
  end

  create_table "queue_slots", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.integer "client_id", null: false
    t.boolean "booted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_queue_slots_on_client_id"
    t.index ["merchant_id"], name: "index_queue_slots_on_merchant_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "join_code", limit: 16
    t.string "transfer_code", limit: 16
    t.string "name", default: ""
    t.integer "qlength", default: 0
    t.integer "queue_slots_count", default: 0
    t.boolean "queue_enabled", default: false
    t.index ["join_code"], name: "index_users_on_join_code"
    t.index ["transfer_code"], name: "index_users_on_transfer_code"
  end

end
