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

ActiveRecord::Schema.define(version: 20161010070138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_versions", force: :cascade do |t|
    t.text     "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.text     "answer",                                 null: false
    t.integer  "author_id",                              null: false
    t.integer  "question_id",                            null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "accepted_corrections_count", default: 0, null: false
    t.integer  "pending_corrections_count",  default: 0, null: false
    t.integer  "current_version_id"
    t.index ["author_id"], name: "index_answers_on_author_id", using: :btree
    t.index ["current_version_id"], name: "index_answers_on_current_version_id", using: :btree
    t.index ["question_id"], name: "index_answers_on_question_id", using: :btree
  end

  create_table "corrections", force: :cascade do |t|
    t.text     "text"
    t.integer  "author_id",   null: false
    t.integer  "answer_id",   null: false
    t.datetime "accepted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["answer_id"], name: "index_corrections_on_answer_id", using: :btree
    t.index ["author_id"], name: "index_corrections_on_author_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title",          limit: 200,             null: false
    t.text     "question",                               null: false
    t.integer  "author_id",                              null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "best_answer_id"
    t.integer  "answers_count",              default: 0, null: false
    t.index ["author_id"], name: "index_questions_on_author_id", using: :btree
    t.index ["best_answer_id"], name: "index_questions_on_best_answer_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username",                            null: false
    t.string   "fullname",                            null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "answers", "answer_versions", column: "current_version_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users", column: "author_id"
  add_foreign_key "corrections", "answers"
  add_foreign_key "corrections", "users", column: "author_id"
  add_foreign_key "questions", "answers", column: "best_answer_id"
  add_foreign_key "questions", "users", column: "author_id"
end
