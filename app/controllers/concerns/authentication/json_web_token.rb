# frozen_string_literal: true

# app/controllers/concerns/authentication/json_web_token.rb
require 'jwt'

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
      # rescue from all decode errors
    rescue JWT::DecodeError => e
      # raise custom error to be handled by custom handler
      raise InvalidTokenError, e.message
    end
  end
end
