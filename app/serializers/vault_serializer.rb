# frozen_string_literal: true

# VaultSerializer class
class VaultSerializer
  include JSONAPI::Serializer
  attributes :name, :created_at, :updated_at
end
