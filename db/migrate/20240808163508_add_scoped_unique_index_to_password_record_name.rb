# frozen_string_literal: true

class AddScopedUniqueIndexToPasswordRecordName < ActiveRecord::Migration[7.1]
  def change
    add_index :password_records, %i[name vault_id], unique: true
  end
end
