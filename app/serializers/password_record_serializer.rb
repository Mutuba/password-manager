# frozen_string_literal: true

# == Schema Information
#
# Table name: password_records
#
#  id           :bigint           not null, primary key
#  vault_id     :bigint           not null
#  name         :string           not null
#  username     :string           not null
#  password     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notes        :text
#  url          :string
#  last_used_at :datetime
#  expired_at   :datetime
#
class PasswordRecordSerializer
  include JSONAPI::Serializer

  attributes :name, :username, :password, :created_at, :updated_at
end
