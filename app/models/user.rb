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
#  first_name      :string           default(""), not null
#  last_name       :string           default(""), not null
#
class User < ApplicationRecord
  has_secure_password
  has_many :vaults

  validates :email, presence: true, uniqueness: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :username, presence: true, uniqueness: true

  validates :password,
    length: { minimum: 6 },
    if: -> { new_record? || !password.nil? }

  def mutuba
    if current_user.email?
      send_email_confirmation
    else
      send_message_notification
    end
  end

  def send_email_confirmation
  end

  def send_message_notification
  end
end
