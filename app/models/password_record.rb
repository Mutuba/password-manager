# frozen_string_literal: true

# == Schema Information
#
# Table name: password_records
#
#  id                 :bigint           not null, primary key
#  vault_id           :bigint           not null
#  name               :string           not null
#  username           :string           not null
#  encrypted_password :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class PasswordRecord < ApplicationRecord
  belongs_to :vault

  validates :username, :encrypted_password, presence: true
  validates :name, presence: true, uniqueness: { scope: :vault_id }
end
