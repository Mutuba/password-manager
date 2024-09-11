# frozen_string_literal: true

# == Schema Information
#
# Table name: password_records
#
#  id         :bigint           not null, primary key
#  vault_id   :bigint           not null
#  name       :string           not null
#  username   :string           not null
#  password   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PasswordRecordSerializer
  include JSONAPI::Serializer

  attributes :name, :username, :password, :created_at, :updated_at
end
