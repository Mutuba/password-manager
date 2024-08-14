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
class Vault < ApplicationRecord
  belongs_to :user
  has_many :password_records

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :encrypted_master_key, :salt, presence: true

  def set_master_key(master_password)
    salt = OpenSSL::Random.random_bytes(16)
    master_key = derive_key_from_password(master_password, salt)
    self.encrypted_master_key = EncryptionService.encrypt_data(master_key, KEK)
    self.salt = salt
    save!
  end

  def get_master_key
    decrypted_key = EncryptionService.decrypt_data(encrypted_master_key, KEK)
    decrypted_key
  end

  private

  def derive_key_from_password(password, salt, iterations = 20000, length = 32)
    OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, 'sha256')
  end
end
