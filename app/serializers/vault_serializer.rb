# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  unlock_code :text             not null
#  salt        :binary           not null
#
class VaultSerializer
  include JSONAPI::Serializer

  attributes :name, :created_at, :updated_at
  has_many :password_records, serializer: PasswordRecordSerializer
end
