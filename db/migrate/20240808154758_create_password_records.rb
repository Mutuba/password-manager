# frozen_string_literal: true

class CreatePasswordRecords < ActiveRecord::Migration[7.1]
  def change
    create_table(:password_records) do |t|
      t.references(:vault, null: false, foreign_key: true)
      t.string(:name, null: false)
      t.string(:username, null: false)
      t.string(:encrypted_password, null: false)

      t.timestamps
    end
  end
end
