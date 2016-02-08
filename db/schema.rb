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

ActiveRecord::Schema.define(version: 20160208151649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collection_configurations", force: :cascade do |t|
    t.integer  "collection_id",              null: false
    t.jsonb    "metadata",      default: {}, null: false
    t.jsonb    "sorts",         default: {}, null: false
    t.jsonb    "facets",        default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collection_users", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "collection_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collection_users", ["collection_id"], name: "index_collection_users_on_collection_id", using: :btree
  add_index "collection_users", ["user_id"], name: "index_collection_users_on_user_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "name_line_1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",                     default: false
    t.string   "unique_id"
    t.boolean  "published"
    t.string   "name_line_2"
    t.boolean  "preview_mode"
    t.string   "url"
    t.text     "site_intro"
    t.text     "short_intro"
    t.text     "about"
    t.text     "copyright"
    t.boolean  "enable_browse"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "uploaded_image_file_name"
    t.string   "uploaded_image_content_type"
    t.integer  "uploaded_image_file_size"
    t.datetime "uploaded_image_updated_at"
    t.boolean  "enable_search"
    t.boolean  "hide_title_on_home_page"
    t.text     "site_path"
  end

  add_index "collections", ["preview_mode"], name: "index_collections_on_preview_mode", using: :btree
  add_index "collections", ["published"], name: "index_collections_on_published", using: :btree
  add_index "collections", ["unique_id"], name: "index_collections_on_unique_id", using: :btree

  create_table "exhibits", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "collection_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about"
    t.string   "uploaded_image_file_name"
    t.string   "uploaded_image_content_type"
    t.integer  "uploaded_image_file_size"
    t.datetime "uploaded_image_updated_at"
    t.text     "copyright"
    t.boolean  "hide_title_on_home_page"
    t.string   "url"
    t.boolean  "enable_search"
    t.boolean  "enable_browse"
  end

  create_table "honeypot_images", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "name"
    t.text     "json_response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "showcase_id"
    t.integer  "exhibit_id"
    t.integer  "collection_id"
  end

  add_index "honeypot_images", ["item_id"], name: "index_honeypot_images_on_item_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "collection_id",      null: false
    t.string   "image_file_name",    null: false
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_fingerprint",  null: false
    t.text     "image_meta"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "images", ["image_fingerprint"], name: "index_images_on_image_fingerprint", using: :btree

  create_table "items", force: :cascade do |t|
    t.text     "name_save"
    t.text     "description_save"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "sortable_name"
    t.integer  "parent_id"
    t.string   "manuscript_url"
    t.boolean  "published"
    t.string   "unique_id"
    t.text     "transcription"
    t.string   "uploaded_image_file_name"
    t.string   "uploaded_image_content_type"
    t.integer  "uploaded_image_file_size"
    t.datetime "uploaded_image_updated_at"
    t.text     "metadata_json"
    t.integer  "image_status",                default: 0
    t.string   "user_defined_id",                          null: false
    t.jsonb    "metadata",                    default: {}, null: false
  end

  add_index "items", ["collection_id", "user_defined_id"], name: "index_items_on_collection_id_and_user_defined_id", unique: true, using: :btree
  add_index "items", ["collection_id"], name: "index_items_on_collection_id", using: :btree
  add_index "items", ["parent_id"], name: "index_items_on_parent_id", using: :btree
  add_index "items", ["published"], name: "index_items_on_published", using: :btree
  add_index "items", ["unique_id"], name: "index_items_on_unique_id", using: :btree

  create_table "items_pages", id: false, force: :cascade do |t|
    t.integer "page_id"
    t.integer "item_id"
  end

  add_index "items_pages", ["item_id", "page_id"], name: "index_items_pages_on_item_id_and_page_id", using: :btree
  add_index "items_pages", ["page_id", "item_id"], name: "index_items_pages_on_page_id_and_item_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "unique_id"
    t.string   "name"
    t.text     "content"
    t.integer  "collection_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "image_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image"
    t.integer  "item_id"
    t.integer  "order"
    t.text     "caption"
    t.integer  "showcase_id"
    t.string   "unique_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.boolean  "has_spacer"
  end

  add_index "sections", ["unique_id"], name: "index_sections_on_unique_id", using: :btree

  create_table "showcases", force: :cascade do |t|
    t.text     "name_line_1"
    t.text     "description"
    t.integer  "exhibit_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.boolean  "published"
    t.string   "unique_id"
    t.string   "name_line_2"
    t.string   "uploaded_image_file_name"
    t.string   "uploaded_image_content_type"
    t.integer  "uploaded_image_file_size"
    t.datetime "uploaded_image_updated_at"
    t.integer  "collection_id"
  end

  add_index "showcases", ["collection_id"], name: "index_showcases_on_collection_id", using: :btree
  add_index "showcases", ["published"], name: "index_showcases_on_published", using: :btree
  add_index "showcases", ["unique_id"], name: "index_showcases_on_unique_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "email",              default: "", null: false
    t.integer  "sign_in_count",      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "collection_configurations", "collections"
  add_foreign_key "collection_users", "collections"
  add_foreign_key "collection_users", "users"
  add_foreign_key "items", "collections"
  add_foreign_key "items", "items", column: "parent_id"
  add_foreign_key "items_pages", "items"
  add_foreign_key "items_pages", "pages"
  add_foreign_key "pages", "collections"
  add_foreign_key "pages", "images"
  add_foreign_key "sections", "items"
  add_foreign_key "sections", "showcases"
  add_foreign_key "showcases", "collections"
end
