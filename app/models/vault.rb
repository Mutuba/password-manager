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
  belongs_to :user
  has_many :password_records

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
