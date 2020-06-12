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

ActiveRecord::Schema.define(version: 2020_06_12_134945) do

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
    t.string "state"
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
