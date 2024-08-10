# frozen_string_literal: true

# app/services/authenticate_user_service.rb
class AuthenticateUserService < ApplicationService
  Result = Struct.new(:auth_token, :success?, :failure?)

  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def call
    if authenticate_user
      auth_token = Authentication::JsonWebToken.encode(user_id: @user.id)
      Result.new(auth_token, true, false)
    else
      Result.new(nil, false, true)
    end
  end

  private

  attr_reader :username, :password

  def authenticate_user
    @user = User.find_by(username:)
    @user&.authenticate(password)
  end
end
