class Vault < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
  # validates :guest_id, uniqueness: {
  #   scope: [ :restaurant_id, :reservation_date ]
  # }

  belongs_to :user
  has_many :password_records
end
