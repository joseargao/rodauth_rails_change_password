# frozen_string_literal: true

# Top-level documentation comment
class CreateAccountPasswordChangeTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :account_password_change_times do |t|
      t.integer :account_id, null: false
      t.timestamp :changed_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :account_password_change_times, :account_id, unique: true
    add_foreign_key :account_password_change_times, :accounts
  end
end
