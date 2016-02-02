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

ActiveRecord::Schema.define(version: 20160131055131) do

  create_table "answers", force: :cascade do |t|
    t.text     "text",        limit: 65535, null: false
    t.integer  "user_id",     limit: 4
    t.integer  "question_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "badges", force: :cascade do |t|
    t.string   "name",        limit: 255,                   null: false
    t.text     "description", limit: 65535,                 null: false
    t.string   "slug",        limit: 255,                   null: false
    t.integer  "kind",        limit: 4,                     null: false
    t.integer  "level",       limit: 4,                     null: false
    t.boolean  "active",                    default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "badgings", force: :cascade do |t|
    t.integer  "badge_id",       limit: 4
    t.integer  "badgeable_id",   limit: 4
    t.string   "badgeable_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "badgings", ["badge_id"], name: "index_badgings_on_badge_id", using: :btree
  add_index "badgings", ["badgeable_type", "badgeable_id"], name: "index_badgings_on_badgeable_type_and_badgeable_id", using: :btree

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   limit: 4, null: false
    t.integer "descendant_id", limit: 4, null: false
    t.integer "generations",   limit: 4, null: false
  end

  add_index "comment_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_idx", unique: true, using: :btree
  add_index "comment_hierarchies", ["descendant_id"], name: "comment_desc_idx", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "text",             limit: 65535, null: false
    t.integer  "user_id",          limit: 4
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "parent_id",        limit: 4
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "hashtag_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   limit: 4, null: false
    t.integer "descendant_id", limit: 4, null: false
    t.integer "generations",   limit: 4, null: false
  end

  add_index "hashtag_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "hashtag_anc_desc_idx", unique: true, using: :btree
  add_index "hashtag_hierarchies", ["descendant_id"], name: "hashtag_desc_idx", using: :btree

  create_table "hashtaggings", force: :cascade do |t|
    t.integer  "hashtag_id",        limit: 4
    t.integer  "hashtaggable_id",   limit: 4
    t.string   "hashtaggable_type", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "hashtaggings", ["hashtag_id", "hashtaggable_id", "hashtaggable_type"], name: "index_hashtaggings_on_hashtag_hashtaggable", unique: true, using: :btree
  add_index "hashtaggings", ["hashtag_id"], name: "index_hashtaggings_on_hashtag_id", using: :btree
  add_index "hashtaggings", ["hashtaggable_type", "hashtaggable_id"], name: "index_hashtaggings_on_hashtaggable_type_and_hashtaggable_id", using: :btree

  create_table "hashtags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "parent_id",  limit: 4
  end

  add_index "hashtags", ["name"], name: "index_hashtags_on_name", unique: true, using: :btree
  add_index "hashtags", ["user_id"], name: "index_hashtags_on_user_id", using: :btree

  create_table "options", force: :cascade do |t|
    t.string   "text",        limit: 255,                 null: false
    t.boolean  "correct",                 default: false, null: false
    t.integer  "question_id", limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "options", ["question_id"], name: "index_options_on_question_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.boolean  "correct"
    t.integer  "question_id", limit: 4
    t.integer  "option_id",   limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "participants", ["option_id"], name: "index_participants_on_option_id", using: :btree
  add_index "participants", ["question_id"], name: "index_participants_on_question_id", using: :btree
  add_index "participants", ["user_id"], name: "index_participants_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "image",      limit: 255
    t.string   "unique_id",  limit: 255, null: false
    t.string   "source",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "photos", ["unique_id"], name: "index_photos_on_unique_id", unique: true, using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "question_type", limit: 255,             null: false
    t.string   "text",          limit: 255,             null: false
    t.integer  "status",        limit: 4,   default: 0, null: false
    t.integer  "views_count",   limit: 4,   default: 1, null: false
    t.integer  "quiz_id",       limit: 4
    t.integer  "photo_id",      limit: 4
    t.integer  "user_id",       limit: 4
    t.integer  "subdang_id",    limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "questions", ["photo_id"], name: "index_questions_on_photo_id", using: :btree
  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id", using: :btree
  add_index "questions", ["subdang_id"], name: "index_questions_on_subdang_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.string   "title",          limit: 255,   null: false
    t.text     "description",    limit: 65535
    t.string   "featured_image", limit: 255
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "quizzes", ["user_id"], name: "index_quizzes_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "rs_evaluations", force: :cascade do |t|
    t.string   "reputation_name", limit: 255
    t.integer  "source_id",       limit: 4
    t.string   "source_type",     limit: 255
    t.integer  "target_id",       limit: 4
    t.string   "target_type",     limit: 255
    t.float    "value",           limit: 24,    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data",            limit: 65535
  end

  add_index "rs_evaluations", ["reputation_name", "source_id", "source_type", "target_id", "target_type"], name: "index_rs_evaluations_on_reputation_name_and_source_and_target", unique: true, using: :btree
  add_index "rs_evaluations", ["reputation_name"], name: "index_rs_evaluations_on_reputation_name", using: :btree
  add_index "rs_evaluations", ["source_id", "source_type"], name: "index_rs_evaluations_on_source_id_and_source_type", using: :btree
  add_index "rs_evaluations", ["target_id", "target_type"], name: "index_rs_evaluations_on_target_id_and_target_type", using: :btree

  create_table "rs_reputation_messages", force: :cascade do |t|
    t.integer  "sender_id",   limit: 4
    t.string   "sender_type", limit: 255
    t.integer  "receiver_id", limit: 4
    t.float    "weight",      limit: 24,  default: 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rs_reputation_messages", ["receiver_id", "sender_id", "sender_type"], name: "index_rs_reputation_messages_on_receiver_id_and_sender", unique: true, using: :btree
  add_index "rs_reputation_messages", ["receiver_id"], name: "index_rs_reputation_messages_on_receiver_id", using: :btree
  add_index "rs_reputation_messages", ["sender_id", "sender_type"], name: "index_rs_reputation_messages_on_sender_id_and_sender_type", using: :btree

  create_table "rs_reputations", force: :cascade do |t|
    t.string   "reputation_name", limit: 255
    t.float    "value",           limit: 24,    default: 0.0
    t.string   "aggregated_by",   limit: 255
    t.integer  "target_id",       limit: 4
    t.string   "target_type",     limit: 255
    t.boolean  "active",                        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data",            limit: 65535
  end

  add_index "rs_reputations", ["reputation_name", "target_id", "target_type"], name: "index_rs_reputations_on_reputation_name_and_target", unique: true, using: :btree
  add_index "rs_reputations", ["reputation_name"], name: "index_rs_reputations_on_reputation_name", using: :btree
  add_index "rs_reputations", ["target_id", "target_type"], name: "index_rs_reputations_on_target_id_and_target_type", using: :btree

  create_table "subdang_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   limit: 4, null: false
    t.integer "descendant_id", limit: 4, null: false
    t.integer "generations",   limit: 4, null: false
  end

  add_index "subdang_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "subdang_anc_desc_idx", unique: true, using: :btree
  add_index "subdang_hierarchies", ["descendant_id"], name: "subdang_desc_idx", using: :btree

  create_table "subdangs", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.string   "featured_image", limit: 255
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "parent_id",      limit: 4
  end

  add_index "subdangs", ["name"], name: "index_subdangs_on_name", unique: true, using: :btree
  add_index "subdangs", ["user_id"], name: "index_subdangs_on_user_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.text     "details",       limit: 65535, null: false
    t.string   "email_address", limit: 255,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "avatar",                 limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "badgings", "badges"
  add_foreign_key "comments", "users"
  add_foreign_key "hashtaggings", "hashtags"
  add_foreign_key "hashtags", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "participants", "options"
  add_foreign_key "participants", "questions"
  add_foreign_key "participants", "users"
  add_foreign_key "questions", "photos"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "questions", "subdangs"
  add_foreign_key "questions", "users"
  add_foreign_key "quizzes", "users"
  add_foreign_key "subdangs", "users"
end
