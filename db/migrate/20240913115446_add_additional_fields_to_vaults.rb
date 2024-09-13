# frozen_string_literal: true

class AddAdditionalFieldsToVaults < ActiveRecord::Migration[7.1]
  def change
    add_column(:vaults, :description, :text)
    add_column(:vaults, :last_accessed_at, :datetime)
    add_column(:vaults, :vault_type, :integer, default: 0, null: false)
    add_column(:vaults, :status, :integer, default: 0, null: false)
    add_column(:vaults, :access_count, :integer, default: 0, null: false)
    add_column(:vaults, :is_shared, :boolean, default: false)
    add_column(:vaults, :shared_with, :jsonb, default: [])
    add_column(:vaults, :expiration_date, :datetime)
    add_column(:vaults, :encrypted_metadata, :text)
    add_column(:vaults, :failed_attempts, :integer, default: 0)
    add_column(:vaults, :unlock_code_hint, :string)
  end
end
