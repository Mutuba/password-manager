# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id                   :bigint           not null, primary key
#  name                 :string           not null
#  user_id              :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  encrypted_master_key :text             not null
#  salt                 :binary           not null
#
require 'openssl'

class Vault < ApplicationRecord
  belongs_to :user
  has_many :password_records

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :encrypted_master_key, :salt, presence: true

  def add_encrypted_master_key(master_password)
    unless validate_master_password_strength(master_password)
      errors.add(:base, 'Master password must be at least 8 characters long and include letters, numbers, and special characters')
      raise ActiveRecord::RecordInvalid, self
    end

    salt = OpenSSL::Random.random_bytes(16)
    master_key = derive_key_from_password(master_password, salt)
    self.encrypted_master_key = EncryptionService.encrypt_data(data: master_key, encryption_key: KEK)
    self.salt = salt
    save!
  end

  def authenticate_master_password(input_password)
    derived_key = derive_key_from_password(input_password, salt)

    decrypted_master_key = EncryptionService.decrypt_data(
      encrypted_data: encrypted_master_key,
      encryption_key: KEK
    )

    ActiveSupport::SecurityUtils.secure_compare(derived_key, decrypted_master_key)
  rescue OpenSSL::Cipher::CipherError
    false
  end

  private

  def validate_master_password_strength(password)
    password.present? && password.match?(/\A(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])[a-zA-Z\d!@#$%^&*]{8,}\z/)
  end

  def derive_key_from_password(password, salt, iterations = 20_000, length = 32)
    OpenSSL::PKCS5.pbkdf2_hmac(password.to_s, salt, iterations, length, 'sha256')
  end

  alias owner :user
end
