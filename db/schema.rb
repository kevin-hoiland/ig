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

ActiveRecord::Schema.define(:version => 20130918162529) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true

  create_table "billings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscription_number"
    t.string   "subscription_name"
    t.string   "last_four"
    t.string   "expiry_month"
    t.string   "expiry_year"
    t.string   "gateway_subscriber_id"
    t.string   "bill_first_name"
    t.string   "bill_last_name"
    t.string   "bill_company"
    t.string   "bill_street"
    t.string   "bill_city"
    t.string   "bill_state_province"
    t.string   "bill_postal_code"
    t.string   "bill_country",          :default => "United States"
    t.string   "ship_first_name"
    t.string   "ship_last_name"
    t.string   "ship_company"
    t.string   "ship_street"
    t.string   "ship_city"
    t.string   "ship_state_province"
    t.string   "ship_postal_code"
    t.string   "ship_country"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "billings", ["user_id"], :name => "index_billings_on_user_id"

  create_table "deleted_objects", :force => true do |t|
    t.string   "deleted_type"
    t.integer  "user_id"
    t.string   "user_email"
    t.integer  "profile_id"
    t.integer  "billing_subscription_id"
    t.integer  "billing_last_four"
    t.string   "billing_bill_name"
    t.string   "billing_ship_name"
    t.integer  "billing_gateway_subscriber_id"
    t.string   "profile_sex"
    t.string   "profile_location"
    t.string   "profile_age"
    t.string   "votes_count"
    t.string   "rating_count"
    t.text     "reason"
    t.datetime "deleted_object_creation_dt"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "dynamic_texts", :force => true do |t|
    t.string   "location"
    t.integer  "sequence"
    t.text     "content"
    t.integer  "size"
    t.boolean  "visible",    :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "gum_rating_relationships", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "gum_id"
    t.integer  "rank_1"
    t.integer  "rank_2"
    t.integer  "rank_3"
    t.integer  "rank_4"
    t.integer  "rank_5"
    t.text     "comment"
    t.float    "average"
    t.integer  "total"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "gum_rating_relationships", ["profile_id", "gum_id"], :name => "index_gum_rating_relationships_on_profile_id_and_gum_id"

  create_table "gum_shipment_relationships", :force => true do |t|
    t.integer  "gum_id"
    t.integer  "shipment_id"
    t.integer  "pieces"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "gum_shipment_relationships", ["gum_id", "shipment_id"], :name => "index_gum_shipment_relationships_on_gum_id_and_shipment_id"

  create_table "gums", :force => true do |t|
    t.string   "permalink",                       :null => false
    t.string   "title",                           :null => false
    t.string   "upc"
    t.boolean  "active",       :default => true,  :null => false
    t.string   "company",      :default => ""
    t.string   "brand",        :default => ""
    t.string   "flavor",       :default => ""
    t.text     "description"
    t.text     "note"
    t.string   "country",      :default => ""
    t.boolean  "new_release",  :default => false, :null => false
    t.boolean  "discontinued", :default => false, :null => false
    t.string   "image"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "asin"
  end

  add_index "gums", ["permalink"], :name => "index_gums_on_permalink"

  create_table "gums_shipments", :id => false, :force => true do |t|
    t.integer "gum_id"
    t.integer "shipment_id"
  end

  add_index "gums_shipments", ["gum_id", "shipment_id"], :name => "index_gums_shipments_on_gum_id_and_shipment_id"

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.date     "bill_date"
    t.string   "bill_card"
    t.decimal  "bill_amount",         :precision => 5, :scale => 2
    t.string   "ship_first_name"
    t.string   "ship_last_name"
    t.string   "ship_street"
    t.string   "ship_city"
    t.string   "ship_state_province"
    t.string   "ship_postal_code"
    t.string   "ship_country"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscriptions_created", :default => 0, :null => false
    t.integer  "subscriptions_deleted", :default => 0, :null => false
    t.string   "name"
    t.string   "location"
    t.string   "age"
    t.string   "sex"
    t.text     "story"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "shipments", :force => true do |t|
    t.date     "ship_date"
    t.decimal  "product_cost",   :precision => 10, :scale => 2
    t.decimal  "shipping_cost",  :precision => 10, :scale => 2
    t.decimal  "labor_cost",     :precision => 10, :scale => 2
    t.decimal  "sales_tax_cost", :precision => 10, :scale => 2
    t.decimal  "donations_cost", :precision => 10, :scale => 2
    t.decimal  "other_costs",    :precision => 10, :scale => 2
    t.decimal  "income",         :precision => 10, :scale => 2
    t.decimal  "profit",         :precision => 10, :scale => 2
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.datetime "released_at"
    t.text     "notes"
    t.string   "number"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
