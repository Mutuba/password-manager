# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EncryptionService do
  describe '.encrypt_data' do
    let(:master_password) { SecureRandom.uuid }
    let(:salt) { OpenSSL::Random.random_bytes(16) }
    let(:master_key) { OpenSSL::PKCS5.pbkdf2_hmac(master_password.to_s, salt, 20_000, 32, 'sha256') }
    let(:kek) { Base64.strict_encode64(OpenSSL::Random.random_bytes(32)) }

    it 'should encrypt data' do
      result = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)

      expect(result).not_to be_nil
      expect(result).to be_a(String)
      expect(result).not_to be_empty
      parts = result.split('--')
      expect(parts.size).to eq(3)
      decrypted_data = EncryptionService.decrypt_data(encrypted_data: result, encryption_key: kek)
      expect(decrypted_data).to eq(master_key)
    end

    it 'raises an error for incorrect key length' do
      short_key = Base64.strict_encode64(OpenSSL::Random.random_bytes(16)) # 16 bytes instead of 32

      expect do
        EncryptionService.encrypt_data(data: master_key, encryption_key: short_key)
      end.to raise_error(ArgumentError, 'key must be 32 bytes')
    end

    it 'raises an error when encrypted data is tampered with' do
      result = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)
      tampered_result = result.sub(result[10], 'x')

      expect do
        EncryptionService.decrypt_data(encrypted_data: tampered_result, encryption_key: kek)
      end.to raise_error(OpenSSL::Cipher::CipherError)
    end
  end
end
