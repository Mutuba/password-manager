# frozen_string_literal: true

# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  def login
    result = AuthenticateUserService.call(username: login_params[:username], password: login_params[:password])
    raise AuthenticationError, Message.invalid_credentials unless result.success?

    json_response(auth_token: result.auth_token, username: result[:username])
  end

  private

  def login_params
    params.require(:user).permit(:username, :password)
  end
end
