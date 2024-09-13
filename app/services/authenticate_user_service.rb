# frozen_string_literal: true

class AuthenticateUserService < ApplicationService
  SuccessStruct = Struct.new(:auth_token, :user) do
    def success?
      true
    end
  end

  FailureStruct = Struct.new(:auth_token) do
    def success?
      false
    end
  end

  def initialize(username:, password:)
    super()
    @username = username
    @password = password
  end

  def call
    if authenticate_user
      auth_token = Authentication::JsonWebToken.encode(user_id: @user.id)
      SuccessStruct.new(
        auth_token,
        { username: @user.username, first_name: @user.first_name, last_name: @user.last_name },
      )
    else
      FailureStruct.new(nil)
    end
  end

  private

  attr_reader :username, :password

  def authenticate_user
    @user = User.find_by(username:)
    @user&.authenticate(password)
  end
end
