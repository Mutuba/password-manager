class User < ApplicationRecord
  has_secure_password

  validates :password_digest, :username, presence: true
  validates :username, uniqueness: true

  has_many :vaults
end
