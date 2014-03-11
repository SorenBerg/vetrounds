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

ActiveRecord::Schema.define(version: 20140307075600) do

  create_table "agreements", force: true do |t|
    t.integer  "question_id"
    t.integer  "answer_id"
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details", force: true do |t|
    t.integer  "user_id"
    t.string   "zipcode"
    t.string   "area_of_practise"
    t.string   "vetinary_school"
    t.string   "vetinary_school_year"
    t.string   "degree"
    t.string   "licence_number"
    t.string   "licence_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "animal_type"
    t.integer  "animal_age"
    t.integer  "medication"
    t.text     "medication_detail"
    t.integer  "flea_preventives"
    t.text     "flea_preventives_detail"
    t.integer  "current_medical_conditions"
    t.text     "current_medical_conditions_detail"
    t.integer  "previous_medical_conditions"
    t.text     "previous_medical_conditions_detail"
    t.text     "feed_pet_detail"
    t.boolean  "answered",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "thanks", force: true do |t|
    t.integer  "question_id"
    t.integer  "answer_id"
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "is_vet"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",                default: true
    t.boolean  "is_admin",               default: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
