# frozen_string_literal: true

# spec/support/request_spec_helper
require 'json'

module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  # generate tokens from user id
  def token_generator(user_id)
    Authentication::JsonWebToken.encode(user_id:)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    Authentication::JsonWebToken.encode({ user_id: }, (Time.now.to_i - 10))
  end

  # return valid headers
  # car = {:make => "bmw", :year => "2003"}
  def valid_headers(user)
    {
      'Authorization' => token_generator(user.id),
      'Content-Type' => 'application/json'
    }
  end

  # return invalid headers
  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type' => 'application/json'
    }
  end
end
