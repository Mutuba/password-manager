# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  unlock_code        :text             not null
#  salt               :binary           not null
#  description        :text
#  last_accessed_at   :datetime
#  vault_type         :integer          default("personal"), not null
#  status             :integer          default("active"), not null
#  access_count       :integer          default(0), not null
#  is_shared          :boolean          default(FALSE)
#  shared_with        :jsonb
#  expiration_date    :datetime
#  encrypted_metadata :text
#  failed_attempts    :integer          default(0)
#  unlock_code_hint   :string
#
require "openssl"

class Vault < ApplicationRecord
  include UnlockCodeValidation
  include KeyDerivable

  enum status: { active: 0, archived: 1, deleted: 2, locked: 3 }
  enum vault_type: { personal: 0, business: 1, shared: 2, temporary: 3 }

  belongs_to :user
  has_many :password_records, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :unlock_code, :salt, presence: true

  before_save :encrypt_unlock_code, if: :unlock_code_changed_or_its_new_record?
  before_validation :generate_salt, if: :new_record?

  def generate_salt
    self.salt = OpenSSL::Random.random_bytes(16)
  end

  def encrypt_unlock_code
    master_key = derive_key_from_input(unlock_code, salt)
    self.unlock_code = EncryptionService.encrypt_data(data: master_key, encryption_key: KEK)
  end

  def unlock_code_changed_or_its_new_record?
    unlock_code_changed? || new_record?
  end

  def authenticate_vault(vault_password)
    derived_key = derive_key_from_input(vault_password, salt)

    decrypted_master_key = derive_vault_master_key

    ActiveSupport::SecurityUtils.secure_compare(derived_key, decrypted_master_key)
  rescue OpenSSL::Cipher::CipherError
    false
  end

  def derive_vault_master_key
    EncryptionService.decrypt_data(
      encrypted_data: unlock_code,
      encryption_key: KEK,
    )
  end

  alias_method :owner, :user
end
