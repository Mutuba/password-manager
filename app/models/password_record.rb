class PasswordRecord < ApplicationRecord
  belongs_to :vault
  validates :username, :encrypted_password, presence: true
  validates :name, presence: true,  uniqueness: { scope: :vault_id }
end
