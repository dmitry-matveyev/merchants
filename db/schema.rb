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

ActiveRecord::Schema.define(version: 2020_05_24_121323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "email"
    t.integer "status"
    t.decimal "total_transaction_sum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status"], name: "index_merchants_on_status"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "merchant_id"
    t.uuid "uuid"
    t.decimal "amount"
    t.string "type"
    t.integer "status"
    t.string "customer_email"
    t.string "customer_phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_transactions_on_merchant_id"
    t.index ["type"], name: "index_transactions_on_type"
    t.index ["uuid"], name: "index_transactions_on_uuid"
  end

end
