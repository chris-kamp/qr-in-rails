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

ActiveRecord::Schema.define(version: 2021_07_13_045919) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "state_id", null: false
    t.bigint "street_id", null: false
    t.bigint "postcode_id", null: false
    t.bigint "suburb_id", null: false
    t.bigint "business_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_addresses_on_business_id"
    t.index ["postcode_id"], name: "index_addresses_on_postcode_id"
    t.index ["state_id"], name: "index_addresses_on_state_id"
    t.index ["street_id"], name: "index_addresses_on_street_id"
    t.index ["suburb_id"], name: "index_addresses_on_suburb_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_businesses_on_category_id"
    t.index ["user_id"], name: "index_businesses_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "checkins", force: :cascade do |t|
    t.bigint "business_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_checkins_on_business_id"
    t.index ["user_id"], name: "index_checkins_on_user_id"
  end

  create_table "postcodes", force: :cascade do |t|
    t.integer "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "business_id", null: false
    t.decimal "rating"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_reviews_on_business_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "streets", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "suburbs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.text "bio"
    t.boolean "public"
  end

  add_foreign_key "addresses", "businesses"
  add_foreign_key "addresses", "postcodes"
  add_foreign_key "addresses", "states"
  add_foreign_key "addresses", "streets"
  add_foreign_key "addresses", "suburbs"
  add_foreign_key "businesses", "categories"
  add_foreign_key "businesses", "users"
  add_foreign_key "checkins", "businesses"
  add_foreign_key "checkins", "users"
  add_foreign_key "reviews", "businesses"
  add_foreign_key "reviews", "users"
end
