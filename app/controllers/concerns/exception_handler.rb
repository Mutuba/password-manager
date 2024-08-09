# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class InvalidTokenError < StandardError; end
  class MissingTokenError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      json_response({ error: error.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      json_response({ error: error.message }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |error|
      json_response({ errors: error.record.errors }, :unprocessable_entity)
    end

    rescue_from AuthenticationError, with: :authentication_error
    rescue_from InvalidTokenError, with: :invalid_token_error
    rescue_from MissingTokenError, with: :missing_token_error
  end

  private

  def authentication_error(error)
    json_response({ error: error.message }, :unauthorized)
  end

  def invalid_token_error(error)
    json_response({ error: error.message }, :unauthorized)
  end

  def missing_token_error(error)
    json_response({ error: error.message }, :unauthorized)
  end
end
