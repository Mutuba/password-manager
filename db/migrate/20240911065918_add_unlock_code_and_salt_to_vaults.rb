# frozen_string_literal: true

class AddUnlockCodeAndSaltToVaults < ActiveRecord::Migration[7.1]
  def change
    add_column(:vaults, :unlock_code, :text, null: false)
    add_column(:vaults, :salt, :binary, null: false)
  end
end
