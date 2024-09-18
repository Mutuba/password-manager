# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 2024_09_18_090327) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "password_records", force: :cascade do |t|
    t.bigint("vault_id", null: false)
    t.string("name", null: false)
    t.string("username", null: false)
    t.string("password", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.text("notes")
    t.string("url")
    t.datetime("last_used_at")
    t.datetime("expired_at")
    t.index(["name", "vault_id"], name: "index_password_records_on_name_and_vault_id", unique: true)
    t.index(["username", "vault_id"], name: "index_password_records_on_username_and_vault_id", unique: true)
    t.index(["vault_id"], name: "index_password_records_on_vault_id")
  end

  create_table "users", force: :cascade do |t|
    t.string("username", null: false)
    t.string("password_digest", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.string("email")
    t.string("first_name", default: "", null: false)
    t.string("last_name", default: "", null: false)
    t.index(["email"], name: "index_users_on_email", unique: true)
    t.index(["username"], name: "index_users_on_username", unique: true)
  end

  create_table "vaults", force: :cascade do |t|
    t.string("name", null: false)
    t.bigint("user_id", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.text("unlock_code", null: false)
    t.binary("salt", null: false)
    t.text("description")
    t.datetime("last_accessed_at")
    t.integer("vault_type", default: 0, null: false)
    t.integer("status", default: 0, null: false)
    t.integer("access_count", default: 0, null: false)
    t.boolean("is_shared", default: false)
    t.jsonb("shared_with", default: [])
    t.datetime("expiration_date")
    t.text("encrypted_metadata")
    t.integer("failed_attempts", default: 0)
    t.string("unlock_code_hint")
    t.index(["name", "user_id"], name: "index_vaults_on_name_and_user_id", unique: true)
    t.index(["user_id"], name: "index_vaults_on_user_id")
  end

  add_foreign_key "password_records", "vaults"
  add_foreign_key "vaults", "users"
end
