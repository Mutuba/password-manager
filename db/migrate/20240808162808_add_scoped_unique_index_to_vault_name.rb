# frozen_string_literal: true

class AddScopedUniqueIndexToVaultName < ActiveRecord::Migration[7.1]
  def change
    add_index :vaults, %i[name user_id], unique: true
  end
end
