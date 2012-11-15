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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121115112137) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.text     "description"
    t.integer  "organisation_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "companies_departments", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "department_id"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "organisation_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "emails", :force => true do |t|
    t.string   "subject"
    t.string   "body"
    t.datetime "created"
    t.datetime "sent"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "deadline"
    t.text     "description"
    t.string   "location"
    t.integer  "capacity"
    t.string   "google_map_url"
    t.string   "requirements"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "organisation_domains", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "domain"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "placements", :force => true do |t|
    t.integer  "company_id"
    t.string   "position"
    t.text     "description"
    t.string   "duration"
    t.string   "location"
    t.datetime "deadline"
    t.string   "open_to"
    t.string   "salary"
    t.text     "benefits"
    t.text     "application_procedure"
    t.datetime "interview_date"
    t.text     "other"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "department_id"
    t.integer  "year"
    t.text     "bio"
    t.text     "degree"
    t.string   "cv_location"
    t.string   "transcript_location"
    t.string   "covering_letter_location"
    t.string   "profile_picture_location"
    t.integer  "company_id"
    t.string   "type"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

end
