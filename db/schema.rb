# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 2) do

  create_table "projects", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
    t.column "user_id",     :integer
    t.column "created_at",  :datetime
    t.column "updated_at",  :datetime
  end

  add_index "projects", ["name"], :name => "index_projects_on_name"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "users", :force => true do |t|
    t.column "login",                     :string
    t.column "email",                     :string
    t.column "crypted_password",          :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
    t.column "activation_code",           :string,   :limit => 40
    t.column "activated_at",              :datetime
  end

  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["email"], :name => "index_users_on_email"

end