# frozen_string_literal: true

class AddUniqueIndexToPasswordRecordsUsername < ActiveRecord::Migration[7.1]
  def change
    add_index(:password_records, [:username, :vault_id], unique: true)
  end
end
