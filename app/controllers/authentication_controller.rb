# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  def login
    result = AuthenticateUserService.call(username: login_params[:username], password: login_params[:password])
    raise AuthenticationError, Message.invalid_credentials unless result.success?

    json_response(auth_token: result.auth_token, user: result[:user])
  end

  def session
    json_response(user: {
      username: current_user.username,
      first_name: current_user.first_name,
      last_name: current_user.last_name,
    })
  end

  private

  def login_params
    params.require(:user).permit(:username, :password)
  end
end
