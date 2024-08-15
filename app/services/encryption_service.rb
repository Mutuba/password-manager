# frozen_string_literal: true

require 'openssl'
require 'base64'

# EncryptionService class
class EncryptionService
  # Encrypts the provided data using AES-256-GCM.
  #
  # @param data [String] The plaintext data to be encrypted.
  # @param encryption_key [String] The Base64 encoded 256-bit encryption key.
  # @return [String] The IV, encrypted data, and auth tag, encoded in Base64, separated by "--".
  def self.encrypt_data(data:, encryption_key:)
    cipher = OpenSSL::Cipher::AES256.new(:GCM)
    cipher.encrypt
    cipher.key = decode_and_validate_key(encryption_key)
    cipher.iv = iv = cipher.random_iv
    encrypted = cipher.update(data) + cipher.final
    auth_tag = cipher.auth_tag
    
    "#{Base64.encode64(iv)}--#{Base64.encode64(encrypted)}--#{Base64.encode64(auth_tag)}"
  end

  # Decrypts the provided encrypted data using AES-256-GCM.
  #
  # @param encrypted_data [String] The Base64 encoded IV, encrypted data, and auth tag, separated by "--".
  # @param encryption_key [String] The Base64 encoded 256-bit encryption key.
  # @return [String] The decrypted plaintext data.
  # @raise [OpenSSL::Cipher::CipherError] if decryption fails (e.g., if data was tampered with).
  def self.decrypt_data(encrypted_data:, encryption_key:)
    iv, encrypted, auth_tag = encrypted_data.split("--").map { |v| Base64.decode64(v) }
    
    cipher = OpenSSL::Cipher::AES256.new(:GCM)
    cipher.decrypt
    cipher.key = decode_and_validate_key(encryption_key)
    cipher.iv = iv
    cipher.auth_tag = auth_tag
    cipher.update(encrypted) + cipher.final
  end

  private

  # Decodes the Base64 encoded encryption key and validates its length.
  #
  # @param key [String] The Base64 encoded encryption key.
  # @return [String] The decoded encryption key.
  # @raise [ArgumentError] If the key is not 32 bytes long.
  def self.decode_and_validate_key(key)
    decoded_key = Base64.decode64(key)
    raise ArgumentError, 'key must be 32 bytes' unless decoded_key.bytesize == 32
    decoded_key
  end
end
