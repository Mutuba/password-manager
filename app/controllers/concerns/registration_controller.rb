# frozen_string_literal: true

# app/controllers/users_controller.rb
class RegistrationController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def signup
    user = User.create!(user_params)
    auth_token = AuthenticateUserService.call(username: user.username, password: user.password)
    response = { message: Message.account_created, auth_token: }
    json_response(response, :created)
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password
    )
  end
end
