# frozen_string_literal: true

# CreateRodauth
class CreateRodauth < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'citext'

    create_table :accounts do |t|
      t.integer :status, null: false, default: 1
      t.citext :email, null: false
      t.index :email, unique: true, where: 'status IN (1, 2)'
      t.string :password_hash
    end
  end
end
