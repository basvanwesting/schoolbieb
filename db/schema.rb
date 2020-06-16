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

ActiveRecord::Schema.define(version: 2020_06_16_083635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "middle_name"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "reading_level"
    t.string "avi_level"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "series"
    t.integer "part"
    t.boolean "sticker_pending", default: true, null: false
    t.string "sti_type"
    t.string "category"
    t.string "tags", default: [], array: true
    t.string "state"
    t.boolean "overdue", default: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["tags"], name: "index_books_on_tags", using: :gin
  end

  create_table "lenders", force: :cascade do |t|
    t.string "identifier"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "group_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.bigint "book_id"
    t.bigint "lender_id"
    t.date "lending_date"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "return_date"
    t.index ["book_id"], name: "index_loans_on_book_id"
    t.index ["lender_id"], name: "index_loans_on_lender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "books", "authors"
  add_foreign_key "loans", "books"
  add_foreign_key "loans", "lenders"
end
