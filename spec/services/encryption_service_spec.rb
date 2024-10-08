# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EncryptionService) do
  describe "data encryption and decryption" do
    let(:unlock_code) { SecureRandom.uuid }
    let(:salt) { OpenSSL::Random.random_bytes(16) }
    let(:master_key) { OpenSSL::PKCS5.pbkdf2_hmac(unlock_code.to_s, salt, 20_000, 32, "sha256") }
    let(:kek) { Base64.strict_encode64(OpenSSL::Random.random_bytes(32)) }

    it "should encrypt data" do
      result = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)

      expect(result).not_to(be_nil)
      expect(result).to(be_a(String))
      expect(result).not_to(be_empty)
      parts = result.split("--")
      expect(parts.size).to(eq(3))
      decrypted_data = EncryptionService.decrypt_data(encrypted_data: result, encryption_key: kek)
      expect(decrypted_data).to(eq(master_key))
    end

    it "raises an error for incorrect key length" do
      short_key = Base64.strict_encode64(OpenSSL::Random.random_bytes(16)) # 16 bytes instead of 32

      expect do
        EncryptionService.encrypt_data(data: master_key, encryption_key: short_key)
      end.to(raise_error(ArgumentError, "key must be 32 bytes"))
    end

    it "raises an error when encrypted data is tampered with" do
      result = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)
      tampered_result = result.sub(result[10], "x")

      expect do
        EncryptionService.decrypt_data(encrypted_data: tampered_result, encryption_key: kek)
      end.to(raise_error(OpenSSL::Cipher::CipherError))
    end

    it "raises an error when decrypting with a different key" do
      different_key = Base64.strict_encode64(OpenSSL::Random.random_bytes(32))
      result = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)

      expect do
        EncryptionService.decrypt_data(encrypted_data: result, encryption_key: different_key)
      end.to(raise_error(OpenSSL::Cipher::CipherError))
    end

    it "correctly encrypts and decrypts empty data" do
      result = EncryptionService.encrypt_data(data: "", encryption_key: kek)

      decrypted_data = EncryptionService.decrypt_data(encrypted_data: result, encryption_key: kek)
      expect(decrypted_data).to(eq(""))
    end

    it "correctly encrypts and decrypts a string with special characters" do
      special_data = '!@#$%^&*()_+-={}[]|:;<>,.?/~`'
      result = EncryptionService.encrypt_data(data: special_data, encryption_key: kek)

      decrypted_data = EncryptionService.decrypt_data(encrypted_data: result, encryption_key: kek)
      expect(decrypted_data).to(eq(special_data))
    end

    it "raises an error when decrypting with a different IV" do
      result = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)
      parts = result.split("--")
      tampered_iv = Base64.strict_encode64(OpenSSL::Random.random_bytes(12))
      tampered_result = [tampered_iv, parts[1], parts[2]].join("--")

      expect do
        EncryptionService.decrypt_data(encrypted_data: tampered_result, encryption_key: kek)
      end.to(raise_error(OpenSSL::Cipher::CipherError))
    end

    it "ensures that encrypting the same data with the same key multiple times results in different outputs" do
      result1 = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)
      result2 = EncryptionService.encrypt_data(data: master_key, encryption_key: kek)

      expect(result1).not_to(eq(result2))
    end
  end
end
