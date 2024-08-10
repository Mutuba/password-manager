# frozen_string_literal: true

# app/services/authorize_request_service.rb
class AuthorizeRequestService < ApplicationService
  Result = Struct.new(:user, :success?, :failure?, :failure_message)

  def initialize(**headers)
    super()
    @headers = headers
  end

  def call
    result = catch(:authorize_error) do
      return check_user
    end

    result
  end

  private

  attr_reader :headers

  def check_user
    user = find_user
    return user if user.success?

    # if no user is found, it throws an error
    throw :authorize_error, user
  end

  def find_user
    @user ||= User.find(decoded_auth_token[:user_id])
    Result.new(@user, true, false, nil)
  rescue ActiveRecord::RecordNotFound
    Result.new(nil, false, true, Message.invalid_token)
  end

  def decoded_auth_token
    @decoded_auth_token ||= Authentication::JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      headers['Authorization'].split(' ').last
    else
      throw :authorize_error, Result.new(nil, false, true, Message.missing_headers)
    end
  end
end
