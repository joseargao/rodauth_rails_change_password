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

ActiveRecord::Schema[7.1].define(version: 20_240_607_054_301) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'citext'
  enable_extension 'plpgsql'

  create_table 'account_password_change_times', force: :cascade do |t|
    t.integer 'account_id', null: false
    t.datetime 'changed_at', precision: nil, default: -> { 'CURRENT_TIMESTAMP' }, null: false
    t.index ['account_id'], name: 'index_account_password_change_times_on_account_id', unique: true
  end

  create_table 'accounts', force: :cascade do |t|
    t.integer 'status', default: 1, null: false
    t.citext 'email', null: false
    t.string 'password_hash'
    t.index ['email'], name: 'index_accounts_on_email', unique: true, where: '(status = ANY (ARRAY[1, 2]))'
  end

  add_foreign_key 'account_password_change_times', 'accounts'
end
