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

ActiveRecord::Schema.define(version: 20150519124517) do

  create_table "collection_users", force: :cascade do |t|
    t.integer  "user_id",       limit: 4, null: false
    t.integer  "collection_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collection_users", ["collection_id"], name: "index_collection_users_on_collection_id", using: :btree
  add_index "collection_users", ["user_id"], name: "index_collection_users_on_user_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "name_line_1", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",     limit: 1,     default: false
    t.text     "description", limit: 65535
    t.string   "unique_id",   limit: 255
    t.boolean  "published",   limit: 1
    t.string   "name_line_2", limit: 255
  end

  add_index "collections", ["published"], name: "index_collections_on_published", using: :btree
  add_index "collections", ["unique_id"], name: "index_collections_on_unique_id", using: :btree

  create_table "exhibits", force: :cascade do |t|
    t.text     "title",              limit: 65535
    t.text     "description",        limit: 65535
    t.integer  "collection_id",      limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.text     "short_description",  limit: 65535
    t.text     "about",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "honeypot_images", force: :cascade do |t|
    t.integer  "item_id",       limit: 4
    t.string   "title",         limit: 255
    t.text     "json_response", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "showcase_id",   limit: 4
    t.integer  "exhibit_id",    limit: 4
  end

  add_index "honeypot_images", ["item_id"], name: "index_honeypot_images_on_item_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.text     "name",               limit: 65535
    t.text     "description",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id",      limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.text     "sortable_name",      limit: 65535
    t.integer  "parent_id",          limit: 4
    t.string   "manuscript_url",     limit: 255
    t.boolean  "published",          limit: 1
    t.string   "unique_id",          limit: 255
    t.text     "transcription",      limit: 65535
  end

  add_index "items", ["collection_id"], name: "index_items_on_collection_id", using: :btree
  add_index "items", ["parent_id"], name: "index_items_on_parent_id", using: :btree
  add_index "items", ["published"], name: "index_items_on_published", using: :btree
  add_index "items", ["unique_id"], name: "index_items_on_unique_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.string   "image",       limit: 255
    t.integer  "item_id",     limit: 4
    t.integer  "order",       limit: 4
    t.text     "caption",     limit: 65535
    t.integer  "showcase_id", limit: 4
    t.string   "unique_id",   limit: 255
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "sections", ["unique_id"], name: "index_sections_on_unique_id", using: :btree

  create_table "showcases", force: :cascade do |t|
    t.text     "title",              limit: 65535
    t.text     "description",        limit: 65535
    t.integer  "exhibit_id",         limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.boolean  "published",          limit: 1
    t.string   "unique_id",          limit: 255
    t.integer  "order",              limit: 4
    t.string   "subtitle",           limit: 255
  end

  add_index "showcases", ["order"], name: "index_showcases_on_order", using: :btree
  add_index "showcases", ["published"], name: "index_showcases_on_published", using: :btree
  add_index "showcases", ["unique_id"], name: "index_showcases_on_unique_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",         limit: 255
    t.string   "last_name",          limit: 255
    t.string   "display_name",       limit: 255
    t.string   "email",              limit: 255, default: "", null: false
    t.integer  "sign_in_count",      limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip", limit: 255
    t.string   "last_sign_in_ip",    limit: 255
    t.string   "username",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",              limit: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
