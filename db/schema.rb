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

ActiveRecord::Schema.define(version: 20_150_319_124_651) do
  create_table 'collection_users', force: true do |t|
    t.integer 'user_id',       null: false
    t.integer 'collection_id', null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'collection_users', ['collection_id'], name: 'index_collection_users_on_collection_id', using: :btree
  add_index 'collection_users', ['user_id'], name: 'index_collection_users_on_user_id', using: :btree

  create_table 'collections', force: true do |t|
    t.string 'title'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.boolean 'deleted',     default: false
    t.text 'description'
    t.string 'unique_id'
  end

  add_index 'collections', ['unique_id'], name: 'index_collections_on_unique_id', using: :btree

  create_table 'exhibits', force: true do |t|
    t.text 'title'
    t.text 'description'
    t.integer 'collection_id'
    t.string 'image_file_name'
    t.string 'image_content_type'
    t.integer 'image_file_size'
    t.datetime 'image_updated_at'
  end

  create_table 'honeypot_images', force: true do |t|
    t.integer 'item_id'
    t.string 'title'
    t.text 'json_response'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'showcase_id'
    t.integer 'exhibit_id'
  end

  add_index 'honeypot_images', ['item_id'], name: 'index_honeypot_images_on_item_id', using: :btree

  create_table 'items', force: true do |t|
    t.text 'title'
    t.text 'description'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'collection_id'
    t.string 'image_file_name'
    t.string 'image_content_type'
    t.integer 'image_file_size'
    t.datetime 'image_updated_at'
    t.text 'sortable_title'
    t.integer 'parent_id'
    t.string 'manuscript_url'
    t.boolean 'published'
    t.string 'unique_id'
    t.text 'transcription'
  end

  add_index 'items', ['collection_id'], name: 'index_items_on_collection_id', using: :btree
  add_index 'items', ['parent_id'], name: 'index_items_on_parent_id', using: :btree
  add_index 'items', ['published'], name: 'index_items_on_published', using: :btree
  add_index 'items', ['unique_id'], name: 'index_items_on_unique_id', using: :btree

  create_table 'sections', force: true do |t|
    t.string 'title'
    t.text 'description'
    t.string 'image'
    t.integer 'item_id'
    t.integer 'order'
    t.text 'caption'
    t.integer 'showcase_id'
    t.string 'unique_id'
    t.datetime 'updated_at'
    t.datetime 'created_at'
  end

  add_index 'sections', ['unique_id'], name: 'index_sections_on_unique_id', using: :btree

  create_table 'showcases', force: true do |t|
    t.text 'title'
    t.text 'description'
    t.integer 'exhibit_id'
    t.string 'image_file_name'
    t.string 'image_content_type'
    t.integer 'image_file_size'
    t.datetime 'image_updated_at'
    t.datetime 'updated_at'
    t.datetime 'created_at'
    t.boolean 'published'
    t.string 'unique_id'
  end

  add_index 'showcases', ['published'], name: 'index_showcases_on_published', using: :btree
  add_index 'showcases', ['unique_id'], name: 'index_showcases_on_unique_id', using: :btree

  create_table 'users', force: true do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'display_name'
    t.string 'email',              default: '', null: false
    t.integer 'sign_in_count',      default: 0
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'username'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.boolean 'admin'
  end

  add_index 'users', ['email'], name: 'index_users_on_email', using: :btree
  add_index 'users', ['username'], name: 'index_users_on_username', unique: true, using: :btree

  create_table 'versions', force: true do |t|
    t.string 'item_type',  null: false
    t.integer 'item_id',    null: false
    t.string 'event',      null: false
    t.string 'whodunnit'
    t.text 'object'
    t.datetime 'created_at'
  end

  add_index 'versions', %w(item_type item_id), name: 'index_versions_on_item_type_and_item_id', using: :btree
end
