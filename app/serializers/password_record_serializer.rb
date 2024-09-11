# frozen_string_literal: true

class PasswordRecordSerializer
  include JSONAPI::Serializer

  attributes :name, :username, :password, :created_at, :updated_at
end
