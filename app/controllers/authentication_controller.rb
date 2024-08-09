# frozen_string_literal: true

# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate
  # return auth token once user is authenticated
  def authenticate
    result = AuthenticateUser.call(username: auth_params[:username], password: auth_params[:password])
    raise AuthenticationError, Message.invalid_credentials unless result.success?

    json_response(auth_token: result[:auth_token])
  end

  private

  def auth_params
    params.require(:authentication).permit(:username, :password)
  end
end
