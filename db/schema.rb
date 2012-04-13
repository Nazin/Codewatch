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

ActiveRecord::Schema.define(:version => 20120413163357) do

  create_table "code_snippets", :force => true do |t|
    t.string   "title",      :limit => 32, :null => false
    t.text     "code",                     :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "lang"
    t.string   "sha_url"
    t.string   "sha"
  end

  add_index "code_snippets", ["sha"], :name => "index_code_snippets_on_sha", :unique => true
  add_index "code_snippets", ["sha_url"], :name => "index_code_snippets_on_sha_url", :unique => true

  create_table "companies", :force => true do |t|
    t.string "name", :limit => 32, :null => false
    t.string "slug",               :null => false
  end

  create_table "user_companies", :force => true do |t|
    t.integer "user_id",                 :null => false
    t.integer "company_id",              :null => false
    t.integer "role",       :limit => 2, :null => false
  end

  add_index "user_companies", ["company_id"], :name => "index_user_companies_on_company_id"
  add_index "user_companies", ["user_id"], :name => "index_user_companies_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "mail",        :limit => 64,                    :null => false
    t.string   "name",        :limit => 32,                    :null => false
    t.string   "passHash",    :limit => 40,                    :null => false
    t.string   "passSalt",    :limit => 5,                     :null => false
    t.string   "fullName",    :limit => 64
    t.boolean  "havePicture",               :default => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "users", ["mail"], :name => "index_users_on_mail"

end
