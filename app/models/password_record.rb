# frozen_string_literal: true

# == Schema Information
#
# Table name: password_records
#
#  id           :bigint           not null, primary key
#  vault_id     :bigint           not null
#  name         :string           not null
#  username     :string           not null
#  password     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notes        :text
#  url          :string
#  last_used_at :datetime
#  expired_at   :datetime
#
class PasswordRecord < ApplicationRecord
  include KeyDerivable

  belongs_to :vault

  validates :password, presence: true, length: { in: 10.. }, password: true
  validates :name, presence: true, uniqueness: { scope: :vault_id }
  validates :username, presence: true, uniqueness: { scope: :vault_id }

  before_save :encrypt_password, if: :password_changed?

  def encryption_key(encryption_key)
    @encryption_key = encryption_key
  end

  def encrypt_password
    raise ArgumentError, "Encryption key not set" unless @encryption_key

    derived_password_key = derive_key_from_input(@encryption_key, vault.salt)
    self.password = EncryptionService.encrypt_data(data: password, encryption_key: derived_password_key)
  end

  def decrypt_password(decryption_key)
    derived_password_key = derive_key_from_input(decryption_key, vault.salt)

    EncryptionService.decrypt_data(encrypted_data: password, encryption_key: derived_password_key)
  rescue OpenSSL::Cipher::CipherError
    false
  end
end
