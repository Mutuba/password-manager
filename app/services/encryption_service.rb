# frozen_string_literal: true

require 'openssl'
require 'base64'

# EncryptionService class
class EncryptionService
  def self.encrypt_password(master_key:, encryption_key:)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    iv = cipher.random_iv
    cipher.key = encryption_key
    encrypted = cipher.update(master_key) + cipher.final
    "#{Base64.encode64(iv)}--#{Base64.encode64(encrypted)}"
  end

  def self.decrypt_password(encrypted_password, encryption_key)
    iv, encrypted = encrypted_password.split('--').map { |v| Base64.decode64(v) }
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.decrypt
    cipher.iv = iv
    cipher.key = encryption_key
    cipher.update(encrypted) + cipher.final
  end
end
