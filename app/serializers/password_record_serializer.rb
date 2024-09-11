# frozen_string_literal: true

class PasswordRecordSerializer < ActiveModel::Serializer
  attributes :name, :username, :password, :created_at, :updated_at
end
