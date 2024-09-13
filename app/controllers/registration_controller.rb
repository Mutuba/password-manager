# frozen_string_literal: true

# app/controllers/users_controller.rb
class RegistrationController < ApplicationController
  skip_before_action :authorize_request, only: :sign_up

  def sign_up
    user = User.create!(registration_params)
    result = AuthenticateUserService.call(username: user.username, password: user.password)
    raise AuthenticationError, Message.invalid_credentials unless result.success?

    response = { auth_token: result[:auth_token], user: result[:user] }
    json_response(response, :created)
  end

  private

  def registration_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
    )
  end
end
