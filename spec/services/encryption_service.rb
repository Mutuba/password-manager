require 'openssl'
require 'base64'

class EncryptionService < ApplicationService
  def self.encrypt_password(password:, key:)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    iv = cipher.random_iv
    cipher.key = key
    encrypted = cipher.update(password) + cipher.final
    "#{Base64.encode64(iv)}--#{Base64.encode64(encrypted)}"
  end

  def self.decrypt_password(encrypted_password, key)
    iv, encrypted = encrypted_password.split("--").map { |v| Base64.decode64(v) }
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.decrypt
    cipher.iv = iv
    cipher.key = key
    cipher.update(encrypted) + cipher.final
  end
end
