# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string
#
class User < ApplicationRecord
  has_secure_password

  # mount_uploader :avatar, AvatarUploader
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :username, presence: true
  validates :username, uniqueness: true

  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  has_many :vaults
end
