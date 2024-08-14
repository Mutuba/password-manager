# frozen_string_literal: true

class AddEncryptedMasterKeySaltToVault < ActiveRecord::Migration[7.1]
  def change
    add_column :vaults, :encrypted_master_key, :text, null: false
    add_column :vaults, :salt, :binary, null: false
  end
end
