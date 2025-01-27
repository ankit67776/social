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

ActiveRecord::Schema[8.0].define(version: 2025_01_19_001508) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "account"
    t.string "principal_balance"
    t.string "interest_rate"
    t.string "maturity_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "construction_draws", force: :cascade do |t|
    t.bigint "loan_id", null: false
    t.bigint "customer_id", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_construction_draws_on_customer_id"
    t.index ["loan_id"], name: "index_construction_draws_on_loan_id"
  end

  create_table "construction_progresses", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_construction_progresses_on_property_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loan_applications", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.date "creation_date"
    t.text "application_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_loan_applications_on_customer_id"
  end

  create_table "loan_histories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loan_records", force: :cascade do |t|
    t.string "account"
    t.string "categories"
    t.decimal "orig_bal"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account"
    t.jsonb "data"
    t.index ["account"], name: "index_loans_on_account", unique: true
  end

  create_table "payment_schedules", force: :cascade do |t|
    t.bigint "loan_id", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_payment_schedules_on_loan_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "loan_id", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_payments_on_loan_id"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "loan_id", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_properties_on_loan_id"
  end

  create_table "samples", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "data"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.string "username"
    t.string "phone_number"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "construction_draws", "customers"
  add_foreign_key "construction_draws", "loans"
  add_foreign_key "construction_progresses", "properties"
  add_foreign_key "loan_applications", "customers"
  add_foreign_key "payment_schedules", "loans"
  add_foreign_key "payments", "loans"
  add_foreign_key "properties", "loans"
end
