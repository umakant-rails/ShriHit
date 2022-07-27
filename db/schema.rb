# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_20_063809) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airticles_tags", id: false, force: :cascade do |t|
    t.bigint "airticle_id", null: false
    t.bigint "tag_id", null: false
  end

  create_table "article_types", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.text "content"
    t.integer "author_id"
    t.integer "user_id"
    t.integer "article_type_id"
    t.integer "context_id"
    t.string "hindi_title"
    t.string "english_title"
    t.string "video_link"
    t.text "interpretation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_approved"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "sampradaya_id"
    t.text "biography"
    t.date "birth_date"
    t.date "death_date"
    t.boolean "is_approved", default: false
    t.integer "user_id"
    t.boolean "is_saint", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.integer "depth", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "contexts", force: :cascade do |t|
    t.string "name"
    t.boolean "is_approved", default: false
    t.integer "user_id"
    t.integer "theme_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sampradayas", force: :cascade do |t|
    t.string "name"
    t.string "originator"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.string "email"
    t.string "username"
    t.boolean "is_approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "theme_articles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "theme_id"
    t.integer "theme_chapter_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "theme_chapters", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "theme_id"
    t.boolean "is_default", default: true
    t.integer "display_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "biography"
    t.string "mobile"
    t.text "address"
    t.string "city"
    t.string "pincode"
    t.integer "state_id"
    t.date "date_of_birth"
    t.string "facebook_url"
    t.string "youtube_url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username"
    t.integer "role_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
