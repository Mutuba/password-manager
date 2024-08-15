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
  class EncryptionError < ArgumentError; end

  def self.encrypt_data(data:, encryption_key:)
    cipher = initialize_cipher(:encrypt, encryption_key)

    isolation_vector = cipher.random_iv
    encrypted = cipher.update(data) + cipher.final
    auth_tag = cipher.auth_tag

    encode_encrypted_data(isolation_vector, encrypted, auth_tag)
  rescue OpenSSL::Cipher::CipherError => e
    raise e
  rescue ArgumentError => e
    raise EncryptionError, e.message
  rescue StandardError => e
    raise "Unexpected error during encryption: #{e.message}"
  end

  # Decrypts the provided encrypted data using AES-256-GCM.
  #
  # @param encrypted_data [String] The Base64 encoded IV, encrypted data, and auth tag, separated by "--".
  # @param encryption_key [String] The Base64 encoded 256-bit encryption key.
  # @return [String] The decrypted plaintext data.
  # @raise [OpenSSL::Cipher::CipherError] if decryption fails (e.g., if data was tampered with).
  def self.decrypt_data(encrypted_data:, encryption_key:)
    isolation_vector, encrypted, auth_tag = decode_encrypted_data(encrypted_data)
    cipher = initialize_cipher(:decrypt, encryption_key, isolation_vector, auth_tag)

    cipher.update(encrypted) + cipher.final
  rescue OpenSSL::Cipher::CipherError => e    
    raise e
  rescue StandardError => e
    raise "Unexpected error during decryption: #{e.message}"
  end

  # Initializes and configures the AES-256-GCM cipher.
  #
  # @param mode [Symbol] The mode, either :encrypt or :decrypt.
  # @param encryption_key [String] The Base64 encoded 256-bit encryption key.
  # @param isolation_vector [String] The initialization vector for decryption (optional).
  # @param auth_tag [String] The authentication tag for decryption (optional).
  # @return [OpenSSL::Cipher] The configured cipher.
  def self.initialize_cipher(mode, encryption_key, isolation_vector = nil, auth_tag = nil)
    cipher = OpenSSL::Cipher.new('aes-256-gcm')
    cipher.send(mode)
    cipher.key = decode_and_validate_key(encryption_key)
    cipher.iv = isolation_vector if isolation_vector
    cipher.auth_tag = auth_tag if auth_tag
    cipher
  end

  # Encodes the IV, encrypted data, and auth tag into a single string.
  #
  # @param isolation_vector [String] The initialization vector.
  # @param encrypted [String] The encrypted data.
  # @param auth_tag [String] The authentication tag.
  # @return [String] The Base64 encoded data string.
  def self.encode_encrypted_data(isolation_vector, encrypted, auth_tag)
    [isolation_vector, encrypted, auth_tag].map { |v| Base64.encode64(v) }.join('--')
  end

  # Decodes the encrypted data string into its components.
  #
  # @param encrypted_data [String] The Base64 encoded data string.
  # @return [Array<String>] The decoded IV, encrypted data, and auth tag.
  def self.decode_encrypted_data(encrypted_data)
    encrypted_data.split('--').map { |v| Base64.decode64(v) }
  end

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
