# frozen_string_literal: true

# app/services/authorize_request_service.rb
class AuthorizeRequestService < ApplicationService
  def initialize(**headers)
    super()
    @headers = headers
  end

  def call
    { user: }
  end

  private

  attr_reader :headers

  def user
    # check if user is in the database
    # memoize user object
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    # handle user not found
  rescue ActiveRecord::RecordNotFound => e
    # raise custom error
    raise InvalidTokenError, ("#{Message.invalid_token} #{e.message}")
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # check for token in `Authorization` header
  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    raise MissingTokenError, Message.missing_token
  end
end
