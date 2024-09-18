# frozen_string_literal: true

module KeyDerivable
  # Derives a key from the input using PBKDF2 with a given salt
  #
  # @param unlock_code [String] The input to derive the key from
  # @param salt [String] The salt to use for key derivation
  # @param iterations [Integer] The number of iterations for the derivation function (default: 20_000)
  # @param length [Integer] The desired length of the derived key (default: 32 bytes)
  # @return [String] The derived key, encoded as Base64
  def derive_key_from_input(input, salt, iterations = 20_000, length = 32)
    derived_key = OpenSSL::PKCS5.pbkdf2_hmac(input.to_s, salt, iterations, length, "sha256")
    Base64.strict_encode64(derived_key) # Encode the derived key as Base64
  end
end
