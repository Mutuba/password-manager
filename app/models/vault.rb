# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  unlock_code :text             not null
#  salt        :binary           not null
#
require "openssl"

class Vault < ApplicationRecord
  belongs_to :user
  has_many :password_records

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :unlock_code, :salt, presence: true

  validate :unlock_code_strength

  before_save :encrypt_unlock_code, if: :unlock_code_changed?

  before_validation :generate_salt

  def generate_salt
    self.salt ||= OpenSSL::Random.random_bytes(16)
  end

  def encrypt_unlock_code
    master_key = derive_key_from_unlock_code(unlock_code, salt)
    self.unlock_code = EncryptionService.encrypt_data(data: master_key, encryption_key: KEK)
  end

  def authenticate_vault(vault_password)
    derived_key = derive_key_from_unlock_code(vault_password, salt)

    decrypted_master_key = EncryptionService.decrypt_data(
      encrypted_data: unlock_code,
      encryption_key: KEK,
    )

    ActiveSupport::SecurityUtils.secure_compare(derived_key, decrypted_master_key)
  rescue OpenSSL::Cipher::CipherError
    false
  end

  private

  def unlock_code_strength
    return if unlock_code.present? &&
      unlock_code.length >= 8 &&
      unlock_code.count("a-zA-Z") > 0 &&
      unlock_code.count("0-9") > 0 &&
      unlock_code.count("!@#$%^&*") > 0

    errors.add(
      :unlock_code,
      "is weak",
    )
  end

  def derive_key_from_unlock_code(unlock_code, salt, iterations = 20_000, length = 32)
    OpenSSL::PKCS5.pbkdf2_hmac(unlock_code.to_s, salt, iterations, length, "sha256")
  end

  alias_method :owner, :user
end
