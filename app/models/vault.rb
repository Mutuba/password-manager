# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Vault < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
  # validates :guest_id, uniqueness: {
  #   scope: [ :restaurant_id, :reservation_date ]
  # }

  belongs_to :user
  has_many :password_records
end
