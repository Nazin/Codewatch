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

ActiveRecord::Schema.define(:version => 20120529183648) do

  create_table "code_snippets", :force => true do |t|
    t.string   "title",      :limit => 32, :null => false
    t.text     "code",                     :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "lang"
    t.string   "sha"
  end

  add_index "code_snippets", ["sha"], :name => "index_code_snippets_on_sha", :unique => true

  create_table "companies", :force => true do |t|
    t.string "name", :limit => 32, :null => false
    t.string "slug",               :null => false
  end

  create_table "invitations", :force => true do |t|
    t.string  "mail",       :limit => 64,                   :null => false
    t.string  "key",        :limit => 32,                   :null => false
    t.boolean "isActive",                 :default => true
    t.integer "company_id",                                 :null => false
    t.integer "role",       :limit => 2,                    :null => false
  end

  add_index "invitations", ["company_id"], :name => "index_invitations_on_company_id"

  create_table "milestones", :force => true do |t|
    t.string   "name",       :limit => 32, :null => false
    t.datetime "deadline"
    t.integer  "project_id",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name",       :limit => 32,  :null => false
    t.integer  "ptype",      :limit => 2,   :null => false
    t.string   "location",   :limit => 128, :null => false
    t.integer  "company_id",                :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "projects", ["company_id"], :name => "index_projects_on_company_id"

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "servers", :force => true do |t|
    t.string  "name",          :limit => 64,                    :null => false
    t.text    "localRepoPath",                                  :null => false
    t.text    "remotePath",                                     :null => false
    t.integer "stype",         :limit => 2,                     :null => false
    t.string  "host",          :limit => 64,                    :null => false
    t.integer "port",                                           :null => false
    t.string  "password",      :limit => 64,                    :null => false
    t.integer "project_id",                                     :null => false
    t.string  "revision",      :limit => 64
    t.boolean "autoUpdate",                  :default => false
    t.string  "username",      :limit => 64,                    :null => false
  end

  add_index "servers", ["project_id"], :name => "index_servers_on_project_id"

  create_table "tasks", :force => true do |t|
    t.string   "title",               :limit => 64, :null => false
    t.text     "description"
    t.integer  "state",               :limit => 2,  :null => false
    t.integer  "priority",            :limit => 2,  :null => false
    t.date     "deadline"
    t.integer  "project_id",                        :null => false
    t.integer  "milestone_id",                      :null => false
    t.integer  "user_id",                           :null => false
    t.integer  "responsible_user_id",               :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "tasks_histories", :force => true do |t|
    t.integer  "state",               :limit => 2, :null => false
    t.integer  "priority",            :limit => 2, :null => false
    t.integer  "task_id",                          :null => false
    t.integer  "user_id",                          :null => false
    t.integer  "responsible_user_id",              :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "user_actions", :force => true do |t|
    t.string  "key",      :limit => 32,                   :null => false
    t.integer "user_id",                                  :null => false
    t.boolean "isActive",               :default => true
    t.integer "atype",    :limit => 2,                    :null => false
  end

  add_index "user_actions", ["user_id"], :name => "index_user_actions_on_user_id"

  create_table "user_companies", :force => true do |t|
    t.integer "user_id",                 :null => false
    t.integer "company_id",              :null => false
    t.integer "role",       :limit => 2, :null => false
  end

  add_index "user_companies", ["company_id"], :name => "index_user_companies_on_company_id"
  add_index "user_companies", ["user_id"], :name => "index_user_companies_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "mail",            :limit => 64,                    :null => false
    t.string   "name",            :limit => 32,                    :null => false
    t.string   "fullName",        :limit => 64
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                         :default => false
    t.boolean  "isActive",                      :default => false
    t.string   "avatar",          :limit => 16
  end

  add_index "users", ["mail"], :name => "index_users_on_mail"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
