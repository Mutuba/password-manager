# frozen_string_literal: true

# app/controllers/concerns/authentication/json_web_token.rb
module Authentication
  module JsonWebToken
    class << self
      Result = Struct.new(:user_id, :success?, :failure?, :failure_message)
      HMAC_SECRET = Rails.application.credentials.secret_key_base

      def encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, HMAC_SECRET)
      end

      def decode(token)
        body = JWT.decode(token, HMAC_SECRET)[0]
        details = HashWithIndifferentAccess.new(body)
        Result.new(details[:user_id], true, false, nil)
      rescue JWT::DecodeError => e
        Result.new(nil, false, true, e.message)
      end
    end
  end
end
