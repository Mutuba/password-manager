# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authentication::JsonWebToken
  include ExceptionHandler
  include JsonResponse

  before_action :authorize_request
  
  attr_reader :current_user

  private

  def authorize_request
    @current_user = AuthorizeRequestService.call(request.headers)
  end
end
