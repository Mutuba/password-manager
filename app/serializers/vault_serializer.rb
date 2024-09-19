# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  unlock_code        :text             not null
#  salt               :binary           not null
#  description        :text
#  last_accessed_at   :datetime
#  vault_type         :integer          default("personal"), not null
#  status             :integer          default("active"), not null
#  access_count       :integer          default(0), not null
#  is_shared          :boolean          default(FALSE)
#  shared_with        :jsonb
#  expiration_date    :datetime
#  encrypted_metadata :text
#  failed_attempts    :integer          default(0)
#  unlock_code_hint   :string
#
class VaultSerializer
  include JSONAPI::Serializer

  attributes :id,
    :name,
    :created_at,
    :updated_at,
    :last_accessed_at,
    :description,
    :vault_type,
    :shared_with,
    :status,
    :access_count,
    :is_shared,
    :failed_attempts
  has_many :password_records, serializer: PasswordRecordSerializer
end
