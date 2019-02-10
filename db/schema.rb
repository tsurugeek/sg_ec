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

ActiveRecord::Schema.define(version: 2019_01_02_082007) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price"
    t.text "description"
    t.boolean "hidden", default: true, null: false
    t.integer "sort_no"
    t.string "product_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "purchase_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "purchase_id", null: false
    t.bigint "product_id", null: false
    t.string "name"
    t.integer "price", null: false
    t.integer "num", default: 1, null: false
    t.integer "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchase_products_on_product_id"
    t.index ["purchase_id"], name: "index_purchase_products_on_purchase_id"
  end

  create_table "purchases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "type", null: false
    t.integer "state", null: false
    t.datetime "purchased_at"
    t.datetime "delivered_at"
    t.integer "subtotal"
    t.integer "products_num", default: 0, null: false
    t.integer "shipping_cost"
    t.integer "cod_fee"
    t.integer "consumption_tax_rate"
    t.integer "consumption_tax"
    t.integer "total"
    t.date "delivery_scheduled_date"
    t.time "delivery_scheduled_time_start"
    t.time "delivery_scheduled_time_end"
    t.boolean "ref_shipping_address"
    t.boolean "save_shipping_address", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "type"], name: "index_purchases_on_user_id_and_type"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "shipping_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shippable_type", null: false
    t.bigint "shippable_id", null: false
    t.string "name"
    t.string "postal_code"
    t.string "prefecture"
    t.string "city"
    t.string "address"
    t.string "building"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shippable_type", "shippable_id"], name: "index_shipping_addresses_on_shippable_type_and_shippable_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "purchase_products", "products"
  add_foreign_key "purchase_products", "purchases"
end
