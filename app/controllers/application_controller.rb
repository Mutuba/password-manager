# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authentication::JsonWebToken
  include ExceptionHandler
  include JsonResponse

  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    result = AuthorizeRequestService.call(headers: request.headers)
    raise AuthenticationError, result.failure_message unless result.success?

    @current_user = result[:user]
  end
end
