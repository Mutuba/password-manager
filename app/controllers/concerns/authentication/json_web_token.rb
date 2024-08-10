# frozen_string_literal: true

# app/controllers/concerns/authentication/json_web_token.rb
module Authentication
  module JsonWebToken

    HMAC_SECRET = Rails.application.credentials.secret_key_base

    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, HMAC_SECRET)
    end

    def self.decode(token)
      body = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new body
      # rescue decode errors
    rescue JWT::ExpiredSignature => e
      raise "Token has expired: #{e.message}"
    rescue JWT::ImmatureSignature => e
      raise "Token not yet valid: #{e.message}"
    rescue JWT::InvalidIssuerError => e
      raise "Invalid token issuer: #{e.message}"
    rescue JWT::InvalidIatError => e
      raise "Invalid issued-at claim: #{e.message}"
    rescue JWT::VerificationError => e
      raise "Token verification failed: #{e.message}"
    rescue JWT::DecodeError => e
      raise "Token decoding error: #{e.message}"
    end
  end
end
