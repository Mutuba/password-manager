# frozen_string_literal: true

# lib/message.rb
class Message
  class << self
    def not_found(record = "record")
      "Sorry, #{record} not found."
    end

    def invalid_credentials
      "Invalid credentials"
    end

    def invalid_token
      "Invalid token"
    end

    def missing_token
      "Missing token"
    end

    def unauthorized
      "Unauthorized request"
    end

    def expired_token
      "Signature has expired"
    end

    def account_created
      "Account created successfully"
    end

    def account_not_created
      "Account could not be created"
    end

    def missing_headers
      "Missing authorization header"
    end
  end
end
