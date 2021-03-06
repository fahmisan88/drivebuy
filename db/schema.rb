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

ActiveRecord::Schema.define(version: 20171113175654) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "phone"
    t.string "plate_num"
    t.string "car_desc"
    t.float "lat"
    t.float "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "name"
    t.string "desc"
    t.decimal "price"
    t.boolean "available", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meal_type"
    t.string "code"
    t.index ["restaurant_id"], name: "index_meals_on_restaurant_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "meal_id"
    t.integer "quantity"
    t.decimal "sub_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_order_details_on_meal_id"
    t.index ["order_id"], name: "index_order_details_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.bigint "customer_id"
    t.decimal "total"
    t.integer "status", default: 0
    t.datetime "picked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "method", default: 0
    t.string "remark"
    t.string "order_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "restaurant_id"
    t.bigint "customer_id"
    t.string "method"
    t.string "txid"
    t.integer "status", default: 2
    t.string "message"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_payments_on_customer_id"
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["restaurant_id"], name: "index_payments_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.string "prepare_time"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "open", default: false
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_restaurants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "access_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "customers", "users"
  add_foreign_key "meals", "restaurants"
  add_foreign_key "order_details", "meals"
  add_foreign_key "order_details", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "payments", "customers"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "restaurants"
  add_foreign_key "restaurants", "users"
end
